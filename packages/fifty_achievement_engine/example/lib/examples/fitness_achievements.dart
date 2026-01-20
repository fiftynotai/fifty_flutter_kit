import 'dart:async';

import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Fitness achievements with workout tracking and time-based conditions.
class FitnessAchievementsExample extends StatefulWidget {
  const FitnessAchievementsExample({super.key});

  @override
  State<FitnessAchievementsExample> createState() =>
      _FitnessAchievementsExampleState();
}

class _FitnessAchievementsExampleState extends State<FitnessAchievementsExample> {
  late final AchievementController<void> _controller;
  OverlayEntry? _overlayEntry;

  bool _isWorkingOut = false;
  Timer? _workoutTimer;
  int _workoutSeconds = 0;

  @override
  void initState() {
    super.initState();
    _controller = AchievementController(
      achievements: _createAchievements(),
      onUnlock: _onAchievementUnlocked,
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _workoutTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  List<Achievement<void>> _createAchievements() {
    return [
      // Workout count achievements
      const Achievement(
        id: 'first_workout',
        name: 'First Steps',
        description: 'Complete your first workout',
        condition: EventCondition('workout_completed'),
        rarity: AchievementRarity.common,
        points: 10,
        category: 'Workouts',
        icon: Icons.fitness_center,
      ),
      const Achievement(
        id: 'workout_5',
        name: 'Getting Consistent',
        description: 'Complete 5 workouts',
        condition: CountCondition('workout_completed', target: 5),
        rarity: AchievementRarity.uncommon,
        points: 50,
        category: 'Workouts',
        prerequisites: ['first_workout'],
        icon: Icons.fitness_center,
      ),
      const Achievement(
        id: 'workout_20',
        name: 'Fitness Enthusiast',
        description: 'Complete 20 workouts',
        condition: CountCondition('workout_completed', target: 20),
        rarity: AchievementRarity.rare,
        points: 100,
        category: 'Workouts',
        prerequisites: ['workout_5'],
        icon: Icons.emoji_events,
      ),

      // Exercise count achievements
      const Achievement(
        id: 'pushups_50',
        name: 'Push It',
        description: 'Do 50 push-ups total',
        condition: CountCondition('pushup_done', target: 50),
        rarity: AchievementRarity.common,
        points: 25,
        category: 'Exercises',
        icon: Icons.accessibility_new,
      ),
      const Achievement(
        id: 'squats_50',
        name: 'Leg Day',
        description: 'Do 50 squats total',
        condition: CountCondition('squat_done', target: 50),
        rarity: AchievementRarity.common,
        points: 25,
        category: 'Exercises',
        icon: Icons.directions_walk,
      ),
      const Achievement(
        id: 'situps_50',
        name: 'Core Strength',
        description: 'Do 50 sit-ups total',
        condition: CountCondition('situp_done', target: 50),
        rarity: AchievementRarity.common,
        points: 25,
        category: 'Exercises',
        icon: Icons.self_improvement,
      ),

      // Stat-based achievements
      const Achievement(
        id: 'calories_1000',
        name: 'Calorie Burner',
        description: 'Burn 1,000 calories total',
        condition: ThresholdCondition('calories_burned', target: 1000),
        rarity: AchievementRarity.rare,
        points: 75,
        category: 'Stats',
        icon: Icons.local_fire_department,
      ),

      // Time-based achievements
      const Achievement(
        id: 'workout_30min',
        name: 'Endurance',
        description: 'Work out for 30 minutes total',
        condition: ThresholdCondition('total_workout_seconds', target: 1800),
        rarity: AchievementRarity.uncommon,
        points: 50,
        category: 'Time',
        icon: Icons.timer,
      ),

      // Combo achievements
      Achievement(
        id: 'balanced_athlete',
        name: 'Balanced Athlete',
        description: 'Do 50 of each: push-ups, squats, and sit-ups',
        condition: CompositeCondition.and([
          const CountCondition('pushup_done', target: 50),
          const CountCondition('squat_done', target: 50),
          const CountCondition('situp_done', target: 50),
        ]),
        rarity: AchievementRarity.epic,
        points: 200,
        category: 'Special',
        icon: Icons.workspace_premium,
      ),

      // Hidden achievement
      const Achievement(
        id: 'early_bird',
        name: 'Early Bird',
        description: 'Work out before 6 AM (simulated)',
        condition: EventCondition('early_workout'),
        rarity: AchievementRarity.legendary,
        points: 300,
        category: 'Special',
        hidden: true,
        icon: Icons.wb_sunny,
      ),
    ];
  }

  void _onAchievementUnlocked(Achievement<void> achievement) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => AchievementPopup<void>(
        achievement: achievement,
        onDismiss: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _toggleWorkout() {
    setState(() {
      _isWorkingOut = !_isWorkingOut;

      if (_isWorkingOut) {
        _controller.trackEvent('workout_started');
        _workoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            _workoutSeconds++;
            _controller.updateStat('total_workout_seconds', _workoutSeconds);
          });
        });
      } else {
        _workoutTimer?.cancel();
        _controller.trackEvent('workout_completed');
        _controller.incrementStat('calories_burned', 50);
      }
    });
  }

  void _doExercise(String type, int count) {
    _controller.trackEvent('${type}_done', count: count);
    _controller.incrementStat('calories_burned', count * 2);
  }

  void _triggerEarlyBird() {
    _controller.trackEvent('early_workout');
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Achievements'),
      ),
      body: Column(
        children: [
          // Workout timer
          Container(
            margin: const EdgeInsets.all(FiftySpacing.md),
            padding: const EdgeInsets.all(FiftySpacing.lg),
            decoration: BoxDecoration(
              color: _isWorkingOut
                  ? FiftyColors.hunterGreen.withValues(alpha: 0.2)
                  : FiftyColors.surfaceDark,
              borderRadius: FiftyRadii.lgRadius,
              border: Border.all(
                color: _isWorkingOut
                    ? FiftyColors.hunterGreen
                    : FiftyColors.borderDark,
                width: _isWorkingOut ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _formatTime(_workoutSeconds),
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.displayLarge,
                    fontWeight: FiftyTypography.extraBold,
                    color: _isWorkingOut
                        ? FiftyColors.hunterGreen
                        : FiftyColors.cream,
                  ),
                ),
                const SizedBox(height: FiftySpacing.md),
                ElevatedButton.icon(
                  onPressed: _toggleWorkout,
                  icon: Icon(_isWorkingOut ? Icons.stop : Icons.play_arrow),
                  label: Text(_isWorkingOut ? 'End Workout' : 'Start Workout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isWorkingOut ? FiftyColors.burgundy : FiftyColors.hunterGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: FiftySpacing.xl,
                      vertical: FiftySpacing.md,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Exercise buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FiftySpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: _buildExerciseButton(
                    'Push-ups',
                    'pushup',
                    Icons.accessibility_new,
                  ),
                ),
                const SizedBox(width: FiftySpacing.sm),
                Expanded(
                  child: _buildExerciseButton(
                    'Squats',
                    'squat',
                    Icons.directions_walk,
                  ),
                ),
                const SizedBox(width: FiftySpacing.sm),
                Expanded(
                  child: _buildExerciseButton(
                    'Sit-ups',
                    'situp',
                    Icons.self_improvement,
                  ),
                ),
              ],
            ),
          ),

          // Hidden button
          Padding(
            padding: const EdgeInsets.all(FiftySpacing.md),
            child: TextButton(
              onPressed: _triggerEarlyBird,
              child: Text(
                'Simulate Early Morning (5 AM)',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  color: FiftyColors.cream.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FiftySpacing.md),
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                final context = _controller.context;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatChip(
                      'Push-ups',
                      context.getEventCount('pushup_done').toString(),
                    ),
                    _buildStatChip(
                      'Squats',
                      context.getEventCount('squat_done').toString(),
                    ),
                    _buildStatChip(
                      'Sit-ups',
                      context.getEventCount('situp_done').toString(),
                    ),
                    _buildStatChip(
                      'Calories',
                      context.getStat('calories_burned').toStringAsFixed(0),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: FiftySpacing.md),

          // Achievement list
          Expanded(
            child: AchievementList<void>(
              controller: _controller,
              compact: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseButton(String label, String type, IconData icon) {
    return ElevatedButton(
      onPressed: _isWorkingOut ? () => _doExercise(type, 10) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: FiftyColors.slateGrey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: FiftySpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.mdRadius,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: FiftySpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
            ),
          ),
          Text(
            '+10',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelSmall,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.titleSmall,
            fontWeight: FiftyTypography.bold,
            color: FiftyColors.cream,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.labelSmall,
            color: FiftyColors.cream.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
