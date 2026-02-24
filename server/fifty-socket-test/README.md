# Fifty Socket Test Server

Minimal Node.js WebSocket server implementing the Phoenix V2 JSON wire protocol for live-testing the `fifty_socket` Flutter package.

## Quick Start (Local)

```bash
npm install
npm start
```

Server listens on port 4000 by default. Override with `PORT` env var:

```bash
PORT=5000 npm start
```

## Health Check

```bash
curl http://localhost:4000/health
```

## VPS Deployment

1. Copy files to the VPS:

```bash
scp -r . root@76.13.180.77:/opt/fifty-socket-test/
```

2. Install dependencies on the VPS:

```bash
ssh root@76.13.180.77 "cd /opt/fifty-socket-test && npm install --production"
```

3. Install and start the systemd service:

```bash
ssh root@76.13.180.77 "cp /opt/fifty-socket-test/fifty-socket-test.service /etc/systemd/system/ && systemctl daemon-reload && systemctl enable fifty-socket-test && systemctl start fifty-socket-test"
```

4. Verify:

```bash
ssh root@76.13.180.77 "systemctl status fifty-socket-test"
curl http://76.13.180.77:4000/health
```

## Protocol

Phoenix V2 JSON wire format: `[join_ref, ref, topic, event, payload]`

### Supported Operations

| Event       | Topic       | Description                          |
|-------------|-------------|--------------------------------------|
| heartbeat   | phoenix     | Heartbeat ping/pong                  |
| phx_join    | any         | Join a channel                       |
| phx_leave   | any         | Leave a channel                      |
| custom      | echo:*      | Echo payload back + broadcast        |
| custom      | test:*      | Acknowledge + broadcast              |

### WebSocket Paths

- `ws://host:4000/socket`
- `ws://host:4000/socket/websocket`
