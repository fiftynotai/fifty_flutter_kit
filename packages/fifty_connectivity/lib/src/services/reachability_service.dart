import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';

/// Strategy for reachability probing.
enum ReachabilityStrategy {
  /// Perform a DNS lookup to verify internet reachability.
  dnsLookup,

  /// Perform an HTTP HEAD request to verify internet reachability.
  httpHead,
}

/// **ReachabilityService**
///
/// Lightweight, injectable service to determine internet reachability.
///
/// ## Why
/// - Abstracts the probing strategy (DNS vs. HTTP) and allows configurable host/timeout.
/// - Keeps ConnectionViewModel simple and focused on state transitions.
///
/// ## Parameters
/// - `host`: DNS host to resolve when using [ReachabilityStrategy.dnsLookup]. Defaults to `google.com`.
/// - `timeout`: Timeout applied to probes. Defaults to 3 seconds.
/// - `strategy`: Probe strategy (DNS lookup or HTTP HEAD/GET to a health endpoint). Defaults to DNS.
/// - `healthEndpoint`: Endpoint used when [strategy] is HTTP-based.
/// - `http`: Optional GetConnect instance for HTTP probing.
///
/// ## Returns
/// - `Future<bool>` indicating whether internet appears reachable.
///
/// ## Notes
/// - On Web, DNS sockets aren't available; we optimistically return true here to avoid false negatives.
///
/// ## Usage
/// ```dart
/// final service = ReachabilityService();
/// final isOnline = await service.isReachable();
/// ```
class ReachabilityService {
  /// Creates a new [ReachabilityService].
  ///
  /// - [host]: DNS host to resolve (default: 'google.com').
  /// - [timeout]: Probe timeout (default: 3 seconds).
  /// - [strategy]: Probing strategy (default: DNS lookup).
  /// - [healthEndpoint]: HTTP endpoint for HTTP-based probing.
  /// - [http]: Optional GetConnect instance for HTTP requests.
  ReachabilityService({
    this.host = 'google.com',
    this.timeout = const Duration(seconds: 3),
    this.strategy = ReachabilityStrategy.dnsLookup,
    this.healthEndpoint,
    GetConnect? http,
  }) : _http = http ?? GetConnect();

  /// DNS host to resolve when using [ReachabilityStrategy.dnsLookup].
  final String host;

  /// Timeout applied to probes.
  final Duration timeout;

  /// Probe strategy (DNS lookup or HTTP HEAD).
  final ReachabilityStrategy strategy;

  /// Endpoint used when [strategy] is [ReachabilityStrategy.httpHead].
  final Uri? healthEndpoint;

  /// HTTP client for HTTP-based probing.
  final GetConnect _http;

  /// Returns true when internet appears reachable.
  ///
  /// On web platforms, always returns true since DNS lookups are not available.
  Future<bool> isReachable() async {
    if (kIsWeb) {
      // On web we can't perform DNS lookups; returning true avoids showing false negatives.
      return true;
    }
    switch (strategy) {
      case ReachabilityStrategy.dnsLookup:
        try {
          final res = await InternetAddress.lookup(host).timeout(timeout);
          return res.isNotEmpty;
        } catch (_) {
          return false;
        }
      case ReachabilityStrategy.httpHead:
        final ep = healthEndpoint;
        if (ep == null) return false;
        try {
          // Try HEAD first; some backends may reject it, so we fallback to GET on 405.
          final resp = await _http
              .request(ep.toString(), 'HEAD', headers: const {})
              .timeout(timeout);
          final code = resp.statusCode ?? 0;
          if (code >= 200 && code < 300) return true;
          if (code == 405) {
            final getResp = await _http.get(ep.toString()).timeout(timeout);
            final getCode = getResp.statusCode ?? 0;
            return getCode >= 200 && getCode < 300;
          }
          return false;
        } catch (_) {
          return false;
        }
    }
  }
}
