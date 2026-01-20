import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import 'examples/basic_achievements.dart';
import 'examples/rpg_achievements.dart';
import 'examples/fitness_achievements.dart';

void main() {
  runApp(const AchievementEngineExampleApp());
}

/// Example app demonstrating fifty_achievement_engine features.
class AchievementEngineExampleApp extends StatelessWidget {
  const AchievementEngineExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achievement Engine Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: FiftyColors.darkBurgundy,
        appBarTheme: AppBarTheme(
          backgroundColor: FiftyColors.surfaceDark,
          foregroundColor: FiftyColors.cream,
          elevation: 0,
        ),
      ),
      home: const ExampleLauncher(),
    );
  }
}

/// Launcher screen for selecting different examples.
class ExampleLauncher extends StatelessWidget {
  const ExampleLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievement Engine Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(FiftySpacing.md),
        children: [
          _buildExampleTile(
            context,
            title: 'Basic Achievements',
            subtitle: 'Simple event and count-based achievements',
            icon: Icons.star_outline,
            builder: (context) => const BasicAchievementsExample(),
          ),
          const SizedBox(height: FiftySpacing.md),
          _buildExampleTile(
            context,
            title: 'RPG Achievements',
            subtitle: 'Combat, leveling, and quest achievements',
            icon: Icons.sports_esports,
            builder: (context) => const RpgAchievementsExample(),
          ),
          const SizedBox(height: FiftySpacing.md),
          _buildExampleTile(
            context,
            title: 'Fitness Achievements',
            subtitle: 'Workout tracking with time and stat conditions',
            icon: Icons.fitness_center,
            builder: (context) => const FitnessAchievementsExample(),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required WidgetBuilder builder,
  }) {
    return Card(
      color: FiftyColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.lgRadius,
        side: BorderSide(color: FiftyColors.borderDark),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(FiftySpacing.md),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: FiftyColors.burgundy.withValues(alpha: 0.2),
            borderRadius: FiftyRadii.mdRadius,
          ),
          child: Icon(
            icon,
            color: FiftyColors.burgundy,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontWeight: FiftyTypography.bold,
            color: FiftyColors.cream,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            color: FiftyColors.cream.withValues(alpha: 0.7),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: FiftyColors.cream.withValues(alpha: 0.5),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: builder),
          );
        },
      ),
    );
  }
}
