import 'package:fifty_map_engine/fifty_map_engine.dart';

typedef _ShiftFn = Vector2 Function(Vector2 parentSize);

/// **FiftyMapUtils**
///
/// A collection of static utility functions used across the Fifty map engine
/// for calculating precise positions and offsets of entities and events on the grid.
///
/// **Key Features:**
/// - Calculate offsets for rotated sprites
/// - Compute aligned positions for event markers based on [FiftyEventAlignment]
///
/// This class is not instantiable.
class FiftyMapUtils {
  /// Private constructor to prevent instantiation.
  FiftyMapUtils._();

  /// **Offset Based on Rotation**
  ///
  /// Returns a pixel offset to be added to a component's position after applying
  /// a number of [quarterTurns] (clockwise 90 degree increments).
  ///
  /// - [quarterTurns]: Number of 90 degree turns (0 = no rotation, 1 = 90, 2 = 180, 3 = 270)
  /// - [size]: Original size of the component
  ///
  /// **Returns:**
  /// - [Vector2] offset for [quarterTurns] != 0
  /// - `null` if [quarterTurns] is 0 (no adjustment needed)
  static Vector2? getPositionAfterRotation(int quarterTurns, Vector2 size) {
    switch (quarterTurns % 4) {
      case 1:
        return Vector2(0, -size.x); // 90 degrees
      case 2:
        return Vector2(size.x, -size.y); // 180 degrees
      case 3:
        return Vector2(size.y, 0); // 270 degrees
      default:
        return null; // 0 degrees -> no adjustment
    }
  }

  /// **Predefined Positional Offsets for Event Alignments**
  ///
  /// Lookup table for offset functions that determine how event markers
  /// should shift relative to their parent component based on:
  /// - [FiftyEventAlignment]: anchor direction
  /// - [quarterTurns]: rotation of the parent (0-3)
  ///
  /// Each entry maps a [FiftyEventAlignment] to a list of 4 functions, one for each
  /// rotation step.
  static final Map<FiftyEventAlignment, List<_ShiftFn>> _shiftTable = {
    FiftyEventAlignment.bottomLeft: [
      (s) => Vector2(0, 0),
      (s) => Vector2(0, s.x),
      (s) => Vector2(s.x, s.y),
      (s) => Vector2(s.y, 0),
    ],
    FiftyEventAlignment.bottomCenter: [
      (s) => Vector2(s.x / 2, 0),
      (s) => Vector2(s.x / 2, s.y),
      (s) => Vector2(s.x / 2, s.y),
      (s) => Vector2(s.x / 2, s.y),
    ],
    FiftyEventAlignment.bottomRight: [
      (s) => Vector2(s.x, 0),
      (s) => Vector2(0, 0),
      (s) => Vector2(0, s.y),
      (s) => Vector2(s.y, s.x),
    ],
    FiftyEventAlignment.centerLeft: [
      (s) => Vector2(0, s.y / 2),
      (s) => Vector2(s.y / 2, s.x),
      (s) => Vector2(s.x, s.y / 2),
      (s) => Vector2(s.y / 2, 0),
    ],
    FiftyEventAlignment.center: [
      (s) => Vector2(s.x / 2, s.y / 2),
      (s) => Vector2(s.y / 2, s.x / 2),
      (s) => Vector2(s.x / 2, s.y / 2),
      (s) => Vector2(s.y / 2, s.x / 2),
    ],
    FiftyEventAlignment.centerRight: [
      (s) => Vector2(s.x, s.y / 2),
      (s) => Vector2(s.y / 2, 0),
      (s) => Vector2(0, s.y / 2),
      (s) => Vector2(s.y / 2, s.x),
    ],
    FiftyEventAlignment.topLeft: [
      (s) => Vector2(0, s.y),
      (s) => Vector2(s.y, s.x),
      (s) => Vector2(s.x, 0),
      (s) => Vector2(0, 0),
    ],
    FiftyEventAlignment.topCenter: [
      (s) => Vector2(s.x / 2, s.y),
      (s) => Vector2(s.x / 2, s.y),
      (s) => Vector2(s.x / 2, 0),
      (s) => Vector2(0, s.y),
    ],
    FiftyEventAlignment.topRight: [
      (s) => Vector2(s.x, s.y),
      (s) => Vector2(s.y, 0),
      (s) => Vector2(0, 0),
      (s) => Vector2(0, s.x),
    ],
  };

  /// **Aligned Position Based on Rotation and Anchor**
  ///
  /// Calculates the final screen position for an event marker based on:
  /// - [base]: parent's top-left pixel position
  /// - [parentSize]: dimensions of the parent component
  /// - [alignment]: where to anchor the event (e.g., topLeft)
  /// - [quarterTurns]: parent's rotation steps (0-3)
  ///
  /// **Returns:** the shifted `base + offset` for the event marker.
  static Vector2 getAlignedPosition({
    required Vector2 base,
    required Vector2 parentSize,
    required FiftyEventAlignment alignment,
    required int quarterTurns,
  }) {
    final shifts = _shiftTable[alignment]!;
    final shiftFn = shifts[quarterTurns % 4];
    return base + shiftFn(parentSize);
  }
}
