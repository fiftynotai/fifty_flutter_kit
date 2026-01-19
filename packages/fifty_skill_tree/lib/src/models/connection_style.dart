/// Visual style for connections between nodes.
///
/// Determines how the lines connecting skill nodes are rendered.
enum ConnectionStyle {
  /// Continuous solid line.
  ///
  /// Standard connection style showing a clear path between nodes.
  solid,

  /// Dashed line (typically for locked paths).
  ///
  /// Often used to indicate optional or locked connections
  /// that aren't currently active.
  dashed,

  /// Animated flowing effect.
  ///
  /// Creates a visual "energy flow" animation along the connection,
  /// typically used for active/unlocked paths.
  animated,
}
