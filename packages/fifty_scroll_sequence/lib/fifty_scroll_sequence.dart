/// Scroll-driven image sequence animation for Flutter.
///
/// Provides Apple-style frame scrubbing mapped to scroll position,
/// with asset-based loading, LRU caching, and gapless playback.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
///
/// ScrollSequence(
///   frameCount: 120,
///   framePath: 'assets/hero/frame_{index}.webp',
///   scrollExtent: 3000,
///   fit: BoxFit.cover,
/// )
/// ```
library;

export 'src/core/core.dart';
export 'src/loaders/loaders.dart';
export 'src/models/models.dart';
export 'src/utils/utils.dart';
export 'src/widgets/widgets.dart';
