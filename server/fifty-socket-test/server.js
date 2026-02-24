'use strict';

/**
 * Fifty Socket Test Server
 *
 * A minimal WebSocket server that implements the Phoenix V2 JSON wire
 * protocol for live-testing the `fifty_socket` Dart/Flutter package.
 *
 * Phoenix V2 wire format (JSON serialiser):
 *   [join_ref, ref, topic, event, payload]
 *
 * Supported events:
 *   - heartbeat  (topic: "phoenix")
 *   - phx_join   (any topic)
 *   - phx_leave  (any topic)
 *   - custom events on echo:* and test:* channels
 *
 * Health-check endpoint:
 *   GET /health -> { status: "ok", connections: N, channels: N }
 */

const http = require('http');
const { WebSocketServer } = require('ws');

// ---------------------------------------------------------------------------
// Configuration
// ---------------------------------------------------------------------------

/** Server port, configurable via the PORT environment variable. */
const PORT = parseInt(process.env.PORT, 10) || 4000;

/** Allowed WebSocket upgrade paths. */
const ALLOWED_PATHS = ['/socket', '/socket/websocket'];

// ---------------------------------------------------------------------------
// Channel registry
// ---------------------------------------------------------------------------

/**
 * Maps topic strings to Sets of WebSocket clients that have joined that topic.
 * @type {Map<string, Set<import('ws').WebSocket>>}
 */
const channels = new Map();

/**
 * Maps a WebSocket client to the Set of topics it has joined.
 * @type {Map<import('ws').WebSocket, Set<string>>}
 */
const clientTopics = new Map();

/** Total number of active WebSocket connections. */
let connectionCount = 0;

// ---------------------------------------------------------------------------
// Phoenix protocol helpers
// ---------------------------------------------------------------------------

/**
 * Sends a Phoenix V2 JSON message to a single client.
 *
 * @param {import('ws').WebSocket} ws   - Target WebSocket connection.
 * @param {string|null} joinRef         - The join reference.
 * @param {string|null} ref             - The message reference.
 * @param {string}      topic           - The channel topic.
 * @param {string}      event           - The event name.
 * @param {object}      payload         - The message payload.
 */
function send(ws, joinRef, ref, topic, event, payload) {
  if (ws.readyState !== ws.OPEN) return;
  ws.send(JSON.stringify([joinRef, ref, topic, event, payload]));
}

/**
 * Sends a phx_reply response to a client.
 *
 * @param {import('ws').WebSocket} ws       - Target client.
 * @param {string|null}            joinRef  - The join reference.
 * @param {string|null}            ref      - The message reference.
 * @param {string}                 topic    - The channel topic.
 * @param {string}                 status   - Reply status ("ok" or "error").
 * @param {object}                 response - Reply payload.
 */
function reply(ws, joinRef, ref, topic, status, response) {
  send(ws, joinRef, ref, topic, 'phx_reply', { status, response });
}

/**
 * Broadcasts a server-initiated message to all members of a topic except
 * the sender.
 *
 * Server-initiated broadcasts use null for both join_ref and ref.
 *
 * @param {string}                 topic   - The channel topic.
 * @param {string}                 event   - The event name.
 * @param {object}                 payload - The message payload.
 * @param {import('ws').WebSocket} [except] - Optional client to exclude.
 */
function broadcast(topic, event, payload, except) {
  const members = channels.get(topic);
  if (!members) return;

  for (const client of members) {
    if (client !== except && client.readyState === client.OPEN) {
      send(client, null, null, topic, event, payload);
    }
  }
}

/**
 * Broadcasts a server-initiated message to ALL members of a topic,
 * including the sender.
 *
 * @param {string} topic   - The channel topic.
 * @param {string} event   - The event name.
 * @param {object} payload - The message payload.
 */
function broadcastAll(topic, event, payload) {
  const members = channels.get(topic);
  if (!members) return;

  for (const client of members) {
    if (client.readyState === client.OPEN) {
      send(client, null, null, topic, event, payload);
    }
  }
}

// ---------------------------------------------------------------------------
// Event handlers
// ---------------------------------------------------------------------------

/**
 * Handles a heartbeat message from the Phoenix client.
 *
 * @param {import('ws').WebSocket} ws      - Source client.
 * @param {string|null}            joinRef - The join reference (always null).
 * @param {string|null}            ref     - The message reference.
 */
function handleHeartbeat(ws, joinRef, ref) {
  reply(ws, joinRef, ref, 'phoenix', 'ok', {});
}

/**
 * Handles a phx_join event: registers the client in the channel and
 * notifies other members.
 *
 * @param {import('ws').WebSocket} ws      - Joining client.
 * @param {string|null}            joinRef - The join reference.
 * @param {string|null}            ref     - The message reference.
 * @param {string}                 topic   - The topic to join.
 */
function handleJoin(ws, joinRef, ref, topic) {
  // Create channel set if it does not exist yet.
  if (!channels.has(topic)) {
    channels.set(topic, new Set());
  }
  channels.get(topic).add(ws);

  // Track topics per client for cleanup on disconnect.
  if (!clientTopics.has(ws)) {
    clientTopics.set(ws, new Set());
  }
  clientTopics.get(ws).add(topic);

  console.log(`[JOIN]  topic=${topic}  members=${channels.get(topic).size}`);

  // Acknowledge the join.
  reply(ws, joinRef, ref, topic, 'ok', {});

  // Notify other channel members.
  broadcast(topic, 'user_joined', { user: 'anonymous' }, ws);
}

/**
 * Handles a phx_leave event: removes the client from the channel and
 * notifies remaining members.
 *
 * @param {import('ws').WebSocket} ws      - Leaving client.
 * @param {string|null}            joinRef - The join reference.
 * @param {string|null}            ref     - The message reference.
 * @param {string}                 topic   - The topic to leave.
 */
function handleLeave(ws, joinRef, ref, topic) {
  const members = channels.get(topic);
  if (members) {
    members.delete(ws);
    if (members.size === 0) {
      channels.delete(topic);
    }
  }

  const topics = clientTopics.get(ws);
  if (topics) {
    topics.delete(topic);
  }

  console.log(
    `[LEAVE] topic=${topic}  members=${members ? members.size : 0}`
  );

  // Acknowledge the leave.
  reply(ws, joinRef, ref, topic, 'ok', {});

  // Notify remaining channel members.
  broadcast(topic, 'user_left', { user: 'anonymous' });
}

/**
 * Handles a custom event on an echo channel (topic matches `echo:*`).
 * Echoes the payload back to the sender and broadcasts it to all members.
 *
 * @param {import('ws').WebSocket} ws      - Source client.
 * @param {string|null}            joinRef - The join reference.
 * @param {string|null}            ref     - The message reference.
 * @param {string}                 topic   - The echo channel topic.
 * @param {string}                 event   - The custom event name.
 * @param {object}                 payload - The event payload.
 */
function handleEchoEvent(ws, joinRef, ref, topic, event, payload) {
  console.log(`[ECHO]  topic=${topic}  event=${event}`);

  // Reply to sender with echoed payload.
  reply(ws, joinRef, ref, topic, 'ok', payload);

  // Broadcast to all members (including sender) as a channel event.
  broadcastAll(topic, event, payload);
}

/**
 * Handles a custom event on a generic channel (topic matches `test:*`
 * or any other non-echo channel).
 *
 * @param {import('ws').WebSocket} ws      - Source client.
 * @param {string|null}            joinRef - The join reference.
 * @param {string|null}            ref     - The message reference.
 * @param {string}                 topic   - The channel topic.
 * @param {string}                 event   - The custom event name.
 * @param {object}                 payload - The event payload.
 */
function handleGenericEvent(ws, joinRef, ref, topic, event, payload) {
  console.log(`[MSG]   topic=${topic}  event=${event}`);

  // Acknowledge to sender.
  reply(ws, joinRef, ref, topic, 'ok', payload);

  // Broadcast to all members (including sender).
  broadcastAll(topic, event, payload);
}

// ---------------------------------------------------------------------------
// WebSocket message router
// ---------------------------------------------------------------------------

/**
 * Parses and routes an incoming WebSocket message according to the
 * Phoenix V2 JSON wire protocol.
 *
 * @param {import('ws').WebSocket} ws   - Source client.
 * @param {Buffer|string}          data - Raw WebSocket message data.
 */
function onMessage(ws, data) {
  let msg;
  try {
    msg = JSON.parse(data.toString());
  } catch {
    console.warn('[WARN]  Received malformed JSON, ignoring');
    return;
  }

  // Validate message shape: must be an array of exactly 5 elements.
  if (!Array.isArray(msg) || msg.length !== 5) {
    console.warn('[WARN]  Invalid Phoenix message shape, ignoring');
    return;
  }

  const [joinRef, ref, topic, event, payload] = msg;

  // Route by event type.
  if (topic === 'phoenix' && event === 'heartbeat') {
    handleHeartbeat(ws, joinRef, ref);
    return;
  }

  if (event === 'phx_join') {
    handleJoin(ws, joinRef, ref, topic);
    return;
  }

  if (event === 'phx_leave') {
    handleLeave(ws, joinRef, ref, topic);
    return;
  }

  // Custom events require the client to have joined the channel.
  const members = channels.get(topic);
  if (!members || !members.has(ws)) {
    console.warn(`[WARN]  Client sent event on un-joined topic: ${topic}`);
    reply(ws, joinRef, ref, topic, 'error', {
      reason: 'not a member of this channel',
    });
    return;
  }

  // Echo channels mirror the payload back.
  if (topic.startsWith('echo:')) {
    handleEchoEvent(ws, joinRef, ref, topic, event, payload);
    return;
  }

  // All other channels get generic handling.
  handleGenericEvent(ws, joinRef, ref, topic, event, payload);
}

// ---------------------------------------------------------------------------
// Cleanup on disconnect
// ---------------------------------------------------------------------------

/**
 * Removes a disconnected client from all channels and notifies remaining
 * members.
 *
 * @param {import('ws').WebSocket} ws - The disconnected client.
 */
function onClose(ws) {
  connectionCount--;
  console.log(`[DISC]  connections=${connectionCount}`);

  const topics = clientTopics.get(ws);
  if (topics) {
    for (const topic of topics) {
      const members = channels.get(topic);
      if (members) {
        members.delete(ws);
        broadcast(topic, 'user_left', { user: 'anonymous' });
        if (members.size === 0) {
          channels.delete(topic);
        }
      }
    }
    clientTopics.delete(ws);
  }
}

// ---------------------------------------------------------------------------
// HTTP server (health-check endpoint)
// ---------------------------------------------------------------------------

const httpServer = http.createServer((req, res) => {
  if (req.method === 'GET' && req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(
      JSON.stringify({
        status: 'ok',
        connections: connectionCount,
        channels: channels.size,
      })
    );
    return;
  }

  res.writeHead(404, { 'Content-Type': 'text/plain' });
  res.end('Not Found');
});

// ---------------------------------------------------------------------------
// WebSocket server
// ---------------------------------------------------------------------------

const wss = new WebSocketServer({ noServer: true });

httpServer.on('upgrade', (request, socket, head) => {
  const pathname = (request.url || '').split('?')[0];

  if (!ALLOWED_PATHS.includes(pathname)) {
    console.warn(`[WARN]  Rejected upgrade on path: ${pathname}`);
    socket.destroy();
    return;
  }

  wss.handleUpgrade(request, socket, head, (ws) => {
    wss.emit('connection', ws, request);
  });
});

wss.on('connection', (ws) => {
  connectionCount++;
  console.log(`[CONN]  connections=${connectionCount}`);

  ws.on('message', (data) => onMessage(ws, data));
  ws.on('close', () => onClose(ws));
  ws.on('error', (err) => {
    console.error(`[ERR]   ${err.message}`);
  });
});

// ---------------------------------------------------------------------------
// Start server
// ---------------------------------------------------------------------------

httpServer.listen(PORT, () => {
  console.log('='.repeat(56));
  console.log('  Fifty Socket Test Server (Phoenix V2 Protocol)');
  console.log(`  Listening on port ${PORT}`);
  console.log(`  WebSocket paths: ${ALLOWED_PATHS.join(', ')}`);
  console.log(`  Health check:    http://localhost:${PORT}/health`);
  console.log('='.repeat(56));
});
