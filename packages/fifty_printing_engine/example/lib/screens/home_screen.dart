import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printing Engine Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Printing Engine',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Production-grade Flutter package for multi-printer ESC/POS printing',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Version: 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          _buildFeatureCard(
            context,
            icon: Icons.print,
            title: 'Multi-Printer Management',
            description: 'Register and manage multiple Bluetooth and WiFi printers simultaneously',
            color: Colors.blue,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.route,
            title: 'Flexible Routing Strategies',
            description: 'Print to all, select per print, or use role-based routing',
            color: Colors.green,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.bluetooth,
            title: 'Bluetooth & WiFi Support',
            description: 'Works with thermal printers over Bluetooth and network printers',
            color: Colors.purple,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.monitor_heart,
            title: 'Status Monitoring & Health Checks',
            description: 'Real-time printer status updates and periodic health monitoring',
            color: Colors.orange,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.check_circle,
            title: 'Result Tracking',
            description: 'Per-printer success/failure details with error messages',
            color: Colors.red,
          ),

          const SizedBox(height: 24),

          // Quick Start
          Text(
            'Quick Start',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStep(context, 1, 'Go to Printers tab', 'Add your Bluetooth or WiFi printer'),
                  const Divider(height: 24),
                  _buildStep(context, 2, 'Configure routing', 'Choose printing mode and role mappings'),
                  const Divider(height: 24),
                  _buildStep(context, 3, 'Test Print tab', 'Try different printing scenarios'),
                  const Divider(height: 24),
                  _buildStep(context, 4, 'Builder tab', 'Create custom tickets'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Navigation Hint
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Use the bottom navigation to explore different features',
                      style: TextStyle(
                        color: Colors.blue[900],
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(description),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, int number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            '$number',
            style: const TextStyle(
              color: Colors.white,
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
                  color: Colors.grey[600],
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
