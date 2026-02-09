/// Animation Service
///
/// Reactive animation management service that coordinates all battle
/// animations: unit movement, attack strikes, damage popups, and defeat
/// sequences. Each animation is tracked as an [AnimationEvent] with a
/// [Completer] so callers can `await` the animation's completion.
///
/// Uses GetX reactive state so the UI layer can bind to
/// [activeAnimations] and [flashingUnitIds] via `Obx()` to drive
/// widget-level animation controllers.
///
/// **Usage:**
/// ```dart
/// final anim = Get.find<AnimationService>();
/// await anim.playMoveAnimation('p_knight_1', from, to);
/// await anim.playAttackAnimation('p_knight_1', attackerPos, targetPos);
/// await anim.playDamagePopup(targetPos, 3);
/// ```
library;

import 'dart:async';

import 'package:get/get.dart';

import '../models/position.dart';

// ---------------------------------------------------------------------------
// Animation Type
// ---------------------------------------------------------------------------

/// The kind of animation being played.
enum AnimationType {
  /// Unit sliding from one tile to another.
  move,

  /// Attack strike directed at a target tile.
  attack,

  /// Floating damage number popup.
  damage,

  /// Unit defeat / removal animation.
  defeat,
}

// ---------------------------------------------------------------------------
// Animation Event
// ---------------------------------------------------------------------------

/// A single in-flight animation tracked by [AnimationService].
///
/// Each event carries enough context for the UI to render the
/// appropriate animation (e.g. slide direction, damage amount) and
/// exposes a [future] that resolves when the animation completes.
///
/// **Fields:**
/// - [id]: Unique identifier for this event.
/// - [type]: The kind of animation (move, attack, damage, defeat).
/// - [unitId]: The unit this animation is associated with.
/// - [fromPosition]: Starting grid position (used by move animations).
/// - [toPosition]: Target grid position (move destination / attack direction).
/// - [targetUnitId]: The unit being attacked (attack animations only).
/// - [damageAmount]: Damage value for the popup (damage animations only).
/// - [duration]: How long the animation should run.
class AnimationEvent {
  /// Unique identifier for this animation event.
  final String id;

  /// The kind of animation being played.
  final AnimationType type;

  /// The unit this animation is associated with.
  final String unitId;

  /// Starting grid position (for move animations).
  final GridPosition? fromPosition;

  /// Target grid position (move destination / attack target direction).
  final GridPosition? toPosition;

  /// The unit being targeted (for attack animations).
  final String? targetUnitId;

  /// Damage value to display (for damage popup animations).
  final int? damageAmount;

  /// How long this animation should run.
  final Duration duration;

  /// Internal completer that resolves when the animation finishes.
  final Completer<void> _completer;

  /// A future that completes when this animation event is finished.
  Future<void> get future => _completer.future;

  /// Creates an [AnimationEvent].
  AnimationEvent({
    required this.id,
    required this.type,
    required this.unitId,
    this.fromPosition,
    this.toPosition,
    this.targetUnitId,
    this.damageAmount,
    required this.duration,
    required Completer<void> completer,
  }) : _completer = completer;

  @override
  String toString() =>
      'AnimationEvent(id: $id, type: $type, unitId: $unitId)';
}

// ---------------------------------------------------------------------------
// Animation Service
// ---------------------------------------------------------------------------

/// Reactive animation management controller for battle animations.
///
/// Coordinates move, attack, damage-popup, and defeat animations.
/// Each `play*` method creates an [AnimationEvent], adds it to
/// [activeAnimations], and returns a [Future] that resolves when
/// [completeAnimation] is called with the event's [id].
///
/// **Reactive State:**
/// - [activeAnimations]: All currently in-flight animation events.
/// - [isAnimating]: `true` when any animation is active.
/// - [flashingUnitIds]: Units currently showing a brief impact flash.
///
/// **Architecture Note:**
/// This is a SERVICE layer component. The UI reads reactive state via
/// `Get.find<AnimationService>()` and calls [completeAnimation] when a
/// widget-level animation controller finishes. The [BattleActions] layer
/// orchestrates play calls and awaits their futures.
class AnimationService extends GetxController {
  // -------------------------------------------------------------------------
  // Duration Constants
  // -------------------------------------------------------------------------

  /// Duration for unit movement slide animation.
  static const Duration moveDuration = Duration(milliseconds: 300);

  /// Duration for attack strike animation.
  static const Duration attackDuration = Duration(milliseconds: 400);

  /// Duration for floating damage popup animation.
  static const Duration damageDuration = Duration(milliseconds: 800);

  /// Duration for unit defeat / removal animation.
  static const Duration defeatDuration = Duration(milliseconds: 500);

  /// Duration for the brief impact flash overlay on a unit.
  static const Duration flashDuration = Duration(milliseconds: 150);

  // -------------------------------------------------------------------------
  // Reactive State
  // -------------------------------------------------------------------------

  /// All currently in-flight animation events.
  final RxList<AnimationEvent> activeAnimations = <AnimationEvent>[].obs;

  /// Whether any animation is currently active.
  ///
  /// Derived from [activeAnimations] length -- `true` when the list
  /// is non-empty. Useful for blocking player input during animations.
  bool get isAnimating => activeAnimations.isNotEmpty;

  /// Set of unit IDs currently showing a brief impact flash effect.
  ///
  /// A flash is triggered after an attack lands and auto-removes
  /// after [flashDuration].
  final RxSet<String> flashingUnitIds = <String>{}.obs;

  /// Monotonically increasing counter for generating unique event IDs.
  int _nextId = 0;

  // -------------------------------------------------------------------------
  // Play Methods
  // -------------------------------------------------------------------------

  /// Plays a unit movement animation (slide from [from] to [to]).
  ///
  /// Returns a [Future] that completes when [completeAnimation] is called
  /// for this event.
  ///
  /// **Parameters:**
  /// - [unitId]: The unit being moved.
  /// - [from]: Starting grid position.
  /// - [to]: Destination grid position.
  ///
  /// **Duration:** 300ms
  Future<void> playMoveAnimation(
    String unitId,
    GridPosition from,
    GridPosition to,
  ) {
    return _enqueue(
      type: AnimationType.move,
      unitId: unitId,
      fromPosition: from,
      toPosition: to,
      duration: moveDuration,
    );
  }

  /// Plays an attack strike animation from [attackerPos] toward [targetPos].
  ///
  /// Returns a [Future] that completes when [completeAnimation] is called
  /// for this event.
  ///
  /// **Parameters:**
  /// - [attackerId]: The attacking unit.
  /// - [attackerPos]: Position of the attacker.
  /// - [targetPos]: Position of the attack target (used for direction).
  ///
  /// **Duration:** 400ms
  Future<void> playAttackAnimation(
    String attackerId,
    GridPosition attackerPos,
    GridPosition targetPos,
  ) {
    return _enqueue(
      type: AnimationType.attack,
      unitId: attackerId,
      fromPosition: attackerPos,
      toPosition: targetPos,
      duration: attackDuration,
    );
  }

  /// Plays a floating damage number popup at [position].
  ///
  /// The [damage] value is displayed as a rising, fading number above the
  /// tile. The unit ID is derived from the position string since damage
  /// popups are positional rather than unit-centric.
  ///
  /// Returns a [Future] that completes when [completeAnimation] is called
  /// for this event.
  ///
  /// **Parameters:**
  /// - [position]: Grid position where the popup appears.
  /// - [damage]: The damage amount to display.
  ///
  /// **Duration:** 800ms
  Future<void> playDamagePopup(GridPosition position, int damage) {
    return _enqueue(
      type: AnimationType.damage,
      unitId: 'damage_${position.x}_${position.y}',
      toPosition: position,
      damageAmount: damage,
      duration: damageDuration,
    );
  }

  /// Plays a unit defeat / removal animation.
  ///
  /// Returns a [Future] that completes when [completeAnimation] is called
  /// for this event.
  ///
  /// **Parameters:**
  /// - [unitId]: The defeated unit.
  /// - [position]: Grid position where the defeat animation plays.
  ///
  /// **Duration:** 500ms
  Future<void> playDefeatAnimation(String unitId, GridPosition position) {
    return _enqueue(
      type: AnimationType.defeat,
      unitId: unitId,
      toPosition: position,
      duration: defeatDuration,
    );
  }

  // -------------------------------------------------------------------------
  // Completion & Query
  // -------------------------------------------------------------------------

  /// Marks an animation event as complete and removes it from the queue.
  ///
  /// The UI layer calls this when a widget-level animation controller
  /// finishes playback. The associated [Completer] is completed so
  /// any code awaiting the event's [future] can continue.
  ///
  /// **Parameters:**
  /// - [eventId]: The unique ID of the completed animation event.
  void completeAnimation(String eventId) {
    final index = activeAnimations.indexWhere((e) => e.id == eventId);
    if (index == -1) return;

    final event = activeAnimations.removeAt(index);
    if (!event._completer.isCompleted) {
      event._completer.complete();
    }
  }

  /// Whether the given [unitId] has any active animation.
  ///
  /// Checks move, attack, and defeat animations. Useful for preventing
  /// player interaction with a unit that is mid-animation.
  bool isUnitAnimating(String unitId) {
    return activeAnimations.any((e) => e.unitId == unitId);
  }

  /// Triggers a brief impact flash on the given [unitId].
  ///
  /// Adds the unit to [flashingUnitIds] and automatically removes it
  /// after [flashDuration] (150ms). The UI binds to [flashingUnitIds]
  /// to overlay a white flash effect on the unit sprite.
  void triggerFlash(String unitId) {
    flashingUnitIds.add(unitId);
    Future.delayed(flashDuration, () {
      flashingUnitIds.remove(unitId);
    });
  }

  // -------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------

  /// Completes all pending animation completers to prevent memory leaks.
  ///
  /// Called when the controller is disposed. Any code awaiting an
  /// animation future will resolve immediately.
  @override
  void onClose() {
    for (final event in activeAnimations) {
      if (!event._completer.isCompleted) {
        event._completer.complete();
      }
    }
    activeAnimations.clear();
    flashingUnitIds.clear();
    super.onClose();
  }

  // -------------------------------------------------------------------------
  // Internal
  // -------------------------------------------------------------------------

  /// Creates an [AnimationEvent], adds it to [activeAnimations], and
  /// returns the completer's future.
  Future<void> _enqueue({
    required AnimationType type,
    required String unitId,
    GridPosition? fromPosition,
    GridPosition? toPosition,
    String? targetUnitId,
    int? damageAmount,
    required Duration duration,
  }) {
    final id = 'anim_${_nextId++}';
    final completer = Completer<void>();
    final event = AnimationEvent(
      id: id,
      type: type,
      unitId: unitId,
      fromPosition: fromPosition,
      toPosition: toPosition,
      targetUnitId: targetUnitId,
      damageAmount: damageAmount,
      duration: duration,
      completer: completer,
    );
    activeAnimations.add(event);
    return completer.future;
  }
}
