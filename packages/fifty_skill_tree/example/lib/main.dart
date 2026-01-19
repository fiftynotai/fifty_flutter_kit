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
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
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
        title: const Text('Skill Tree Examples'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Choose an Example',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white70,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _ExampleCard(
              title: 'Basic Tree',
              description: 'Simple linear skill progression',
              icon: Icons.account_tree,
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BasicTreeExample()),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'RPG Skill Tree',
              description: 'Multi-branch class skills (Warrior/Mage/Rogue)',
              icon: Icons.shield,
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RpgSkillTreeExample()),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Tech Tree',
              description: 'Strategy game research tree with grid layout',
              icon: Icons.science,
              color: Colors.cyan,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TechTreeExample()),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Talent Tree',
              description: 'MOBA-style talents with 3 paths',
              icon: Icons.bolt,
              color: Colors.amber,
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
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white54,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.white38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
