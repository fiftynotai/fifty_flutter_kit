/// Achievement engine for Flutter games.
///
/// This library provides a complete achievement system with condition-based
/// unlocks, progress tracking, and FDL-compliant UI widgets.
///
/// ## Features
///
/// - **Flexible Condition System**: 6 built-in condition types
/// - **Progress Tracking**: Real-time progress with percentage support
/// - **Event & Stat Tracking**: Track game events and statistics
/// - **Prerequisite Support**: Chain achievements with dependencies
/// - **Rarity Tiers**: Common, Uncommon, Rare, Epic, Legendary
/// - **Serialization**: Save/load progress with JSON support
/// - **FDL-Compliant UI**: Styled widgets using Fifty Design Language
///
/// ## Condition Types
///
/// - [EventCondition] - Triggered by a single event occurrence
/// - [CountCondition] - Requires a cumulative event count
/// - [ThresholdCondition] - Stat reaches a target value
/// - [CompositeCondition] - Combines multiple conditions (AND/OR)
/// - [TimeCondition] - Time-based challenges
/// - [SequenceCondition] - Ordered event sequences
///
/// ## Quick Start
///
/// ```dart
/// import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
///
/// // Create controller with achievements
/// final controller = AchievementController<void>(
///   achievements: [
///     Achievement(
///       id: 'first_kill',
///       name: 'First Blood',
///       description: 'Defeat your first enemy',
///       condition: EventCondition('enemy_killed'),
///       rarity: AchievementRarity.common,
///       points: 10,
///     ),
///     Achievement(
///       id: 'kill_100',
///       name: 'Century',
///       description: 'Defeat 100 enemies',
///       condition: CountCondition('enemy_killed', target: 100),
///       rarity: AchievementRarity.rare,
///       points: 50,
///     ),
///   ],
///   onUnlock: (achievement) {
///     print('Unlocked: ${achievement.name}!');
///   },
/// );
///
/// // Track events
/// controller.trackEvent('enemy_killed');
///
/// // Update stats
/// controller.updateStat('player_level', 50);
///
/// // Check progress
/// final progress = controller.getProgress('kill_100');
/// print('Progress: ${(progress * 100).toStringAsFixed(1)}%');
/// ```
///
/// ## Displaying Achievements
///
/// ```dart
/// // Show achievement list
/// AchievementList(
///   controller: controller,
///   filter: AchievementFilter.all,
///   onTap: (achievement) => showDetails(achievement),
/// )
///
/// // Show summary stats
/// AchievementSummary(
///   controller: controller,
///   showRarityBreakdown: true,
/// )
///
/// // Show unlock popup
/// controller.onUnlock = (achievement) {
///   showOverlay(
///     builder: (context) => AchievementPopup(
///       achievement: achievement,
///       onDismiss: () => hideOverlay(),
///     ),
///   );
/// };
/// ```
///
/// ## Serialization
///
/// ```dart
/// // Export progress for saving
/// final progress = controller.exportProgress();
/// await saveToFile(jsonEncode(progress));
///
/// // Import progress from save file
/// final savedData = await loadFromFile();
/// final data = jsonDecode(savedData) as Map<String, dynamic>;
/// controller.importProgress(data);
/// ```
library;

export 'src/conditions/conditions.dart';
export 'src/controllers/controllers.dart';
export 'src/models/models.dart';
export 'src/serialization/serialization.dart';
export 'src/widgets/widgets.dart';
