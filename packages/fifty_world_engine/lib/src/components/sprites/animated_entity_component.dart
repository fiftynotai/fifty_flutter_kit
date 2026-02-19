import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:fifty_world_engine/src/components/base/model.dart';
import 'package:fifty_world_engine/src/components/base/component.dart';
import 'package:fifty_world_engine/src/animation/sprite_animation_config.dart';

/// Flame component for entities with sprite sheet animation (internal).
///
/// Extends [FiftyMovableComponent] to maintain type compatibility with the
/// entity spawner and registry system. The base sprite is set to the first
/// frame of the default animation, and a child [SpriteAnimationComponent]
/// handles the actual frame-by-frame rendering on top.
///
/// Supports a simple string-based state machine (idle -> walk -> attack -> idle).
///
/// **Note:** This class is INTERNAL to the package. Consumers configure
/// animations via [SpriteAnimationConfig] on [FiftyWorldEntity.spriteAnimation].
class AnimatedEntityComponent extends FiftyMovableComponent {
  /// Sprite animation configuration (frames, states, etc.).
  final SpriteAnimationConfig animConfig;

  /// Current animation state name.
  String _currentState;

  /// Preloaded animations by state name.
  final Map<String, SpriteAnimation> _animations = {};

  /// Child component that renders the active animation.
  late SpriteAnimationComponent _animationRenderer;

  /// Creates an [AnimatedEntityComponent].
  ///
  /// - [model]: the entity data model
  /// - [animConfig]: sprite sheet animation configuration
  AnimatedEntityComponent({
    required super.model,
    required this.animConfig,
  }) : _currentState = animConfig.defaultState;

  /// The current animation state name.
  String get currentState => _currentState;

  @override
  Future<void> onLoad() async {
    // Let the base class handle priority, position, hitbox, events, text, etc.
    await super.onLoad();

    // Load sprite sheet and build animations for each state
    final image = game.images.fromCache(animConfig.spriteSheetAsset);

    for (final entry in animConfig.states.entries) {
      final stateConfig = entry.value;
      final frames = <SpriteAnimationFrame>[];

      for (int i = 0; i < stateConfig.frameCount; i++) {
        final frameSprite = Sprite(
          image,
          srcPosition: Vector2(
            (i * animConfig.frameWidth).toDouble(),
            (stateConfig.row * animConfig.frameHeight).toDouble(),
          ),
          srcSize: Vector2(
            animConfig.frameWidth.toDouble(),
            animConfig.frameHeight.toDouble(),
          ),
        );
        frames.add(SpriteAnimationFrame(frameSprite, stateConfig.stepTime));
      }

      _animations[entry.key] =
          SpriteAnimation(frames, loop: stateConfig.loop);
    }

    // Hide the base sprite (animation renderer covers it)
    opacity = 0;

    // Add the animation renderer as a child covering the full size
    final initialAnim = _animations[_currentState];
    _animationRenderer = SpriteAnimationComponent(
      animation: initialAnim,
      size: size.clone(),
      anchor: Anchor.topLeft,
      position: Vector2.zero(),
    );
    add(_animationRenderer);
  }

  /// Switches to a named animation state.
  ///
  /// If the state doesn't exist in [animConfig.states], this is a no-op.
  /// If already in [stateName], this is a no-op.
  void setState(String stateName) {
    if (stateName == _currentState) return;
    final anim = _animations[stateName];
    if (anim == null) return;
    _currentState = stateName;
    _animationRenderer.animation = anim;
  }

  /// Moves the entity to [newPosition] with animation state transition.
  ///
  /// Switches to the 'walk' state during movement, then returns to the
  /// default state when the movement completes.
  @override
  void moveTo(Vector2 newPosition, FiftyWorldEntity newModel,
      {double speed = 200}) {
    model = newModel;
    setState('walk');
    final distance = newPosition.distanceTo(position);
    final duration = distance / speed;
    add(
      MoveToEffect(
        newPosition,
        EffectController(duration: duration, curve: Curves.easeInOut),
        onComplete: () => setState(animConfig.defaultState),
      ),
    );
    eventComponent?.moveWithParent(newModel);
  }

  /// Plays attack animation state, then returns to default.
  ///
  /// Applies a scale-bounce visual effect alongside the state transition.
  @override
  void attack({VoidCallback? onComplete}) {
    setState('attack');
    // Scale bounce
    add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2(1.2, 1.2),
          EffectController(duration: 0.1, curve: Curves.easeOut),
        ),
        ScaleEffect.to(
          Vector2(1.0, 1.0),
          EffectController(duration: 0.1, curve: Curves.easeIn),
        ),
      ], onComplete: () {
        setState(animConfig.defaultState);
      }),
    );
    if (onComplete != null) {
      Future.delayed(const Duration(milliseconds: 200), onComplete);
    }
  }

  /// Death animation: fade out and remove.
  ///
  /// If a 'die' animation state exists, it is played before fading out.
  @override
  void die({VoidCallback? onComplete}) {
    if (_animations.containsKey('die')) {
      setState('die');
    }
    _animationRenderer.add(
      SequenceEffect([
        OpacityEffect.to(
          0.0,
          EffectController(duration: 0.5, curve: Curves.easeIn),
        ),
      ]),
    );
    add(
      SequenceEffect([
        // Wait for fade to finish, then remove
        OpacityEffect.to(
          0.0,
          EffectController(duration: 0.5, curve: Curves.easeIn),
        ),
        RemoveEffect(),
      ]),
    );
    if (onComplete != null) {
      Future.delayed(const Duration(milliseconds: 500), onComplete);
    }
  }
}
