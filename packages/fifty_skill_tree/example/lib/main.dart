import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import 'examples/basic_tree.dart';
import 'examples/rpg_skill_tree.dart';
import 'examples/talent_tree.dart';
import 'examples/tech_tree.dart';

void main() {
  runApp(const SkillTreeExampleApp());
}

/// Example app demonstrating the fifty_skill_tree package.
class SkillTreeExampleApp extends StatelessWidget {
  const SkillTreeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Tree Examples',
      debugShowCheckedModeBanner: false,
      theme: FiftyTheme.dark(),
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const ExampleHomePage(),
    );
  }
}

/// Home page with navigation to different examples.
class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SKILL TREE EXAMPLES'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: FiftySpacing.lg),
            Text(
              'CHOOSE AN EXAMPLE',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: FiftyColors.hyperChrome,
                    letterSpacing: 2,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: FiftySpacing.xxxl),
            _ExampleCard(
              title: 'BASIC TREE',
              description: 'Simple linear skill progression',
              icon: Icons.account_tree,
              color: FiftyColors.crimsonPulse,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BasicTreeExample()),
              ),
            ),
            const SizedBox(height: FiftySpacing.lg),
            _ExampleCard(
              title: 'RPG SKILL TREE',
              description: 'Multi-branch class skills (Warrior/Mage/Rogue)',
              icon: Icons.shield,
              color: FiftyColors.crimsonPulse,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RpgSkillTreeExample()),
              ),
            ),
            const SizedBox(height: FiftySpacing.lg),
            _ExampleCard(
              title: 'TECH TREE',
              description: 'Strategy game research tree with grid layout',
              icon: Icons.science,
              color: FiftyColors.crimsonPulse,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TechTreeExample()),
              ),
            ),
            const SizedBox(height: FiftySpacing.lg),
            _ExampleCard(
              title: 'TALENT TREE',
              description: 'MOBA-style talents with 3 paths',
              icon: Icons.bolt,
              color: FiftyColors.crimsonPulse,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TalentTreeExample()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FiftyCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(FiftySpacing.xl),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(FiftySpacing.md),
                border: Border.all(
                  color: color.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: FiftySpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: FiftyColors.terminalWhite,
                          letterSpacing: 1,
                        ),
                  ),
                  const SizedBox(height: FiftySpacing.xs),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: FiftyColors.hyperChrome,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: FiftyColors.hyperChrome.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
