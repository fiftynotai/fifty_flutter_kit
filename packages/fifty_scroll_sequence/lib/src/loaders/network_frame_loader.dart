import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'frame_loader.dart';

/// Callback for download progress reporting.
///
/// [bytesReceived] is the number of bytes downloaded so far.
/// [totalBytes] is the expected total from the Content-Length header,
/// or -1 if the server did not provide it.
typedef DownloadProgressCallback = void Function(
  int bytesReceived,
  int totalBytes,
);

/// Loads image sequence frames from network URLs with local disk caching.
///
/// Downloaded frames are cached to [cacheDirectory] so subsequent loads
/// are served from disk without re-downloading. The disk cache persists
/// across app sessions intentionally.
///
/// Uses [HttpClient] from `dart:io` for HTTP requests. This loader is
/// **not available on web** -- use [AssetFrameLoader] for web targets.
///
/// ## URL Pattern
///
/// The [frameUrlPattern] uses `{index}` as a placeholder that gets replaced
/// with the zero-padded frame index. Padding width is auto-detected from
/// [frameCount] unless [indexPadWidth] is explicitly set.
///
/// ## Example
///
/// ```dart
/// final loader = NetworkFrameLoader(
///   frameUrlPattern: 'https://cdn.example.com/hero/frame_{index}.webp',
///   frameCount: 200,
///   cacheDirectory: '/tmp/scroll_cache',
/// );
///
/// final image = await loader.loadFrame(0);
/// // Use image with RawImage widget...
/// image.dispose(); // When done
/// ```
class NetworkFrameLoader implements FrameLoader {
  /// Creates a [NetworkFrameLoader] for the given URL pattern.
  ///
  /// The [cacheDirectory] must be a writable directory path, typically
  /// obtained via `getTemporaryDirectory()` from the `path_provider` package
  /// in the consuming app.
  NetworkFrameLoader({
    required this.frameUrlPattern,
    required this.frameCount,
    required this.cacheDirectory,
    this.headers = const {},
    this.indexPadWidth,
    this.indexOffset = 0,
    this.onDownloadProgress,
  });

  /// URL pattern with `{index}` placeholder.
  ///
  /// Example: `'https://cdn.example.com/seq/frame_{index}.webp'`
  final String frameUrlPattern;

  /// Total number of frames in the sequence.
  final int frameCount;

  /// Local directory path for disk cache storage.
  final String cacheDirectory;

  /// Optional HTTP headers sent with each request (e.g., auth tokens).
  final Map<String, String> headers;

  /// Zero-pad width for the index in the URL.
  ///
  /// If null, auto-detected from [frameCount] + [indexOffset].
  final int? indexPadWidth;

  /// Offset added to the zero-based index before URL substitution.
  ///
  /// Use `1` for 1-based frame numbering on the server.
  final int indexOffset;

  /// Optional callback invoked during each frame download with progress.
  final DownloadProgressCallback? onDownloadProgress;

  /// Shared HTTP client for connection pooling across frame downloads.
  late final HttpClient _httpClient = HttpClient();

  /// Whether the cache directory has been verified to exist.
  bool _cacheDirectoryVerified = false;

  @override
  String resolveFramePath(int index) {
    final adjusted = index + indexOffset;
    final padWidth =
        indexPadWidth ?? (frameCount + indexOffset).toString().length;
    final padded = adjusted.toString().padLeft(padWidth, '0');
    return frameUrlPattern.replaceAll('{index}', padded);
  }

  @override
  Future<ui.Image> loadFrame(int index) async {
    final url = resolveFramePath(index);
    final cacheFile = File('$cacheDirectory/scroll_seq_frame_$index');

    // Check disk cache first
    if (cacheFile.existsSync()) {
      final bytes = await cacheFile.readAsBytes();
      return _decodeImage(bytes);
    }

    // Ensure cache directory exists on first download.
    if (!_cacheDirectoryVerified) {
      final dir = Directory(cacheDirectory);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      _cacheDirectoryVerified = true;
    }

    // Download from network using shared client for connection pooling.
    final request = await _httpClient.getUrl(Uri.parse(url));

    // Set custom headers
    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    final response = await request.close();

    if (response.statusCode != 200) {
      // Drain response body to allow socket reuse.
      await response.drain<void>();
      throw HttpException(
        'Failed to download frame $index: HTTP ${response.statusCode}',
        uri: Uri.parse(url),
      );
    }

    final bytes = await _collectBytes(response);

    // Write to disk cache
    await cacheFile.writeAsBytes(bytes, flush: true);

    return _decodeImage(bytes);
  }

  @override
  void dispose() {
    _httpClient.close();
  }

  /// Decode raw image [bytes] into a [ui.Image].
  Future<ui.Image> _decodeImage(List<int> bytes) async {
    final codec = await ui.instantiateImageCodec(
      bytes is Uint8List ? bytes : Uint8List.fromList(bytes),
    );
    final frame = await codec.getNextFrame();
    codec.dispose();
    return frame.image;
  }

  /// Collect all bytes from [response] with progress reporting.
  Future<Uint8List> _collectBytes(HttpClientResponse response) async {
    final totalBytes = response.contentLength;
    final chunks = <List<int>>[];
    int received = 0;

    await for (final chunk in response) {
      chunks.add(chunk);
      received += chunk.length;
      onDownloadProgress?.call(received, totalBytes);
    }

    final builder = BytesBuilder(copy: false);
    for (final chunk in chunks) {
      builder.add(chunk);
    }
    return builder.takeBytes();
  }
}
