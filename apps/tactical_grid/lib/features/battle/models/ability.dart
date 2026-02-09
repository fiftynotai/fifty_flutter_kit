/// Ability Model
///
/// Represents a unit ability with cooldown tracking, activation logic,
/// and factory constructors for each ability type in the game.
library;

/// Types of abilities available to units.
enum AbilityType {
  /// Commander ability. Buffs adjacent allies with +1 ATK.
  rally,

  /// Knight ability. Passive +2 damage when moved this turn.
  charge,

  /// Shield ability. Reduces next incoming damage by 50%.
  block,

  /// Archer ability. Ranged attack at distance 3.
  shoot,

  /// Mage ability. Deals 1 damage to all units in a 3x3 area.
  fireball,

  /// Scout ability. Reveals traps in a 2-tile radius.
  reveal,
}

/// An ability that a unit can use during battle.
///
/// Abilities have a cooldown system: after activation, they become
/// unavailable for [cooldownMax] turns. Passive abilities (like Charge)
/// are always active and cannot be manually triggered.
///
/// **Example:**
/// ```dart
/// final rally = Ability.rally();
/// print(rally.isReady); // true
/// rally.activate();
/// print(rally.currentCooldown); // 3
/// rally.tickCooldown();
/// print(rally.currentCooldown); // 2
/// ```
class Ability {
  /// The type of this ability.
  final AbilityType type;

  /// Human-readable name.
  final String name;

  /// Short description of the ability effect.
  final String description;

  /// Maximum cooldown turns after activation. 0 for passives.
  final int cooldownMax;

  /// Current cooldown counter. 0 means ready.
  int currentCooldown;

  /// Whether this ability is passive (always active, cannot be triggered).
  final bool isPassive;

  /// Targeting range in tiles. 0 means self-only.
  final int range;

  Ability({
    required this.type,
    required this.name,
    required this.description,
    required this.cooldownMax,
    this.currentCooldown = 0,
    this.isPassive = false,
    this.range = 0,
  });

  /// Whether this ability can be activated (off cooldown and not passive).
  bool get isReady => currentCooldown == 0 && !isPassive;

  /// Activate this ability, starting its cooldown timer.
  ///
  /// Sets [currentCooldown] to [cooldownMax]. Has no effect on passive
  /// abilities.
  void activate() {
    currentCooldown = cooldownMax;
  }

  /// Tick the cooldown down by one turn.
  ///
  /// Decrements [currentCooldown] by 1 if it is greater than 0.
  void tickCooldown() {
    if (currentCooldown > 0) {
      currentCooldown--;
    }
  }

  /// Create a copy with optional field overrides.
  Ability copyWith({
    AbilityType? type,
    String? name,
    String? description,
    int? cooldownMax,
    int? currentCooldown,
    bool? isPassive,
    int? range,
  }) {
    return Ability(
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      cooldownMax: cooldownMax ?? this.cooldownMax,
      currentCooldown: currentCooldown ?? this.currentCooldown,
      isPassive: isPassive ?? this.isPassive,
      range: range ?? this.range,
    );
  }

  /// Creates Rally ability. +1 ATK to adjacent allies. Cooldown: 3 turns.
  factory Ability.rally() {
    return Ability(
      type: AbilityType.rally,
      name: 'Rally',
      description: '+1 ATK to adjacent allies',
      cooldownMax: 3,
      range: 1,
    );
  }

  /// Creates Charge ability. Passive +2 damage if moved this turn.
  factory Ability.charge() {
    return Ability(
      type: AbilityType.charge,
      name: 'Charge',
      description: '+2 damage if moved this turn',
      cooldownMax: 0,
      isPassive: true,
      range: 0,
    );
  }

  /// Creates Block ability. Take 50% damage on next hit. Cooldown: 2 turns.
  factory Ability.block() {
    return Ability(
      type: AbilityType.block,
      name: 'Block',
      description: 'Take 50% damage next hit',
      cooldownMax: 2,
      range: 0,
    );
  }

  /// Creates Shoot ability. Ranged attack at distance 3. Cooldown: 2 turns.
  factory Ability.shoot() {
    return Ability(
      type: AbilityType.shoot,
      name: 'Shoot',
      description: 'Ranged attack at distance 3',
      cooldownMax: 2,
      range: 3,
    );
  }

  /// Creates Fireball ability. 1 damage to 3x3 area. Cooldown: 3 turns.
  factory Ability.fireball() {
    return Ability(
      type: AbilityType.fireball,
      name: 'Fireball',
      description: '1 damage to 3x3 area',
      cooldownMax: 3,
      range: 3,
    );
  }

  /// Creates Reveal ability. Show traps in 2-tile radius. Cooldown: 2 turns.
  factory Ability.reveal() {
    return Ability(
      type: AbilityType.reveal,
      name: 'Reveal',
      description: 'Show traps in 2-tile radius',
      cooldownMax: 2,
      range: 2,
    );
  }

  @override
  String toString() =>
      'Ability($name, cooldown: $currentCooldown/$cooldownMax)';
}
