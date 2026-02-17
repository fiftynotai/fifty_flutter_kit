import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Printing Engine Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Printing Engine',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Production-grade Flutter package for multi-printer ESC/POS printing',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Version: 1.0.0',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Features
          Text(
            'Features',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          _buildFeatureCard(
            context,
            icon: Icons.print,
            title: 'Multi-Printer Management',
            description: 'Register and manage multiple Bluetooth and WiFi printers simultaneously',
            color: colorScheme.primary,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.route,
            title: 'Flexible Routing Strategies',
            description: 'Print to all, select per print, or use role-based routing',
            color: colorScheme.tertiary,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.bluetooth,
            title: 'Bluetooth & WiFi Support',
            description: 'Works with thermal printers over Bluetooth and network printers',
            color: colorScheme.secondary,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.monitor_heart,
            title: 'Status Monitoring & Health Checks',
            description: 'Real-time printer status updates and periodic health monitoring',
            color: colorScheme.tertiary,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.check_circle,
            title: 'Result Tracking',
            description: 'Per-printer success/failure details with error messages',
            color: colorScheme.primary,
          ),

          const SizedBox(height: 24),

          // Quick Start
          Text(
            'Quick Start',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStep(context, 1, 'Go to Printers tab', 'Add your Bluetooth or WiFi printer'),
                  Divider(height: 24, color: colorScheme.outlineVariant),
                  _buildStep(context, 2, 'Configure routing', 'Choose printing mode and role mappings'),
                  Divider(height: 24, color: colorScheme.outlineVariant),
                  _buildStep(context, 3, 'Test Print tab', 'Try different printing scenarios'),
                  Divider(height: 24, color: colorScheme.outlineVariant),
                  _buildStep(context, 4, 'Builder tab', 'Create custom tickets'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Navigation Hint
          Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colorScheme.onPrimaryContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Use the bottom navigation to explore different features',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, int number, String title, String description) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: colorScheme.primary,
          child: Text(
            '$number',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
