import 'package:flame/components.dart';
import 'package:fifty_map_engine/src/components/base/priority.dart';

/// Base class for visual decorators attached to entities.
///
/// Decorators are child components added to entity components. They
/// auto-position relative to the entity (via Flame's parent-child system).
/// All decorators render at [FiftyRenderPriority.decorator].
///
/// Subclasses must implement [onLoad] to set up their visuals.
abstract class EntityDecorator extends PositionComponent {
  EntityDecorator({super.position, super.size})
      : super(priority: FiftyRenderPriority.decorator);
}
