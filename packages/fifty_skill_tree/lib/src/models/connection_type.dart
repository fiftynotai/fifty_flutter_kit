/// Defines the relationship between connected nodes.
///
/// Determines whether prerequisite nodes must be unlocked before
/// the dependent node can be purchased.
enum ConnectionType {
  /// Must unlock parent before child.
  ///
  /// The most common connection type. The child node cannot be
  /// unlocked until the parent node has at least one level.
  required,

  /// Can skip parent node.
  ///
  /// Optional connections show a path but don't enforce prerequisite
  /// requirements. Useful for alternative progression routes.
  optional,

  /// Unlocking locks out sibling nodes.
  ///
  /// Used for mutually exclusive choices where selecting one path
  /// permanently prevents selecting the alternative.
  exclusive,
}
