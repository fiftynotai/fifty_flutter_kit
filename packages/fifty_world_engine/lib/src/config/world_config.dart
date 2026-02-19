/// **Global configuration for the Fifty world engine**
///
/// Contains constants governing grid layout and scale used throughout the package.
///
/// **Constants:**
/// - [blockSize]: the pixel size of a single map block (tile).
///
/// This class is not instantiable.
class FiftyWorldConfig {
  const FiftyWorldConfig._();

  /// Pixel size for each grid block.
  static const double blockSize = 64.0;
}
