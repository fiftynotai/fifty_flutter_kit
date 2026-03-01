import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
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
        padding: EdgeInsets.all(FiftySpacing.lg),
        children: [
          // Header
          FiftyCard(
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Printing Engine',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: FiftySpacing.sm),
                Text(
                  'Production-grade Flutter package for multi-printer ESC/POS printing',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: FiftySpacing.lg),
                Text(
                  'Version: 1.0.0',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: FiftySpacing.xxl),

          // Features
          const FiftySectionHeader(
            title: 'Features',
            size: FiftySectionHeaderSize.large,
          ),

          FiftyListTile(
            leadingIcon: Icons.print,
            leadingIconColor: colorScheme.primary,
            title: 'Multi-Printer Management',
            subtitle:
                'Register and manage multiple Bluetooth and WiFi printers simultaneously',
          ),

          FiftyListTile(
            leadingIcon: Icons.route,
            leadingIconColor: colorScheme.tertiary,
            title: 'Flexible Routing Strategies',
            subtitle:
                'Print to all, select per print, or use role-based routing',
          ),

          FiftyListTile(
            leadingIcon: Icons.bluetooth,
            leadingIconColor: colorScheme.secondary,
            title: 'Bluetooth & WiFi Support',
            subtitle:
                'Works with thermal printers over Bluetooth and network printers',
          ),

          FiftyListTile(
            leadingIcon: Icons.monitor_heart,
            leadingIconColor: colorScheme.tertiary,
            title: 'Status Monitoring & Health Checks',
            subtitle:
                'Real-time printer status updates and periodic health monitoring',
          ),

          FiftyListTile(
            leadingIcon: Icons.check_circle,
            leadingIconColor: colorScheme.primary,
            title: 'Result Tracking',
            subtitle:
                'Per-printer success/failure details with error messages',
          ),

          SizedBox(height: FiftySpacing.xxl),

          // Quick Start
          const FiftySectionHeader(
            title: 'Quick Start',
            size: FiftySectionHeaderSize.large,
          ),

          FiftyCard(
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStep(context, 1, 'Go to Printers tab',
                    'Add your Bluetooth or WiFi printer'),
                FiftyDivider(height: 24),
                _buildStep(context, 2, 'Configure routing',
                    'Choose printing mode and role mappings'),
                FiftyDivider(height: 24),
                _buildStep(context, 3, 'Test Print tab',
                    'Try different printing scenarios'),
                FiftyDivider(height: 24),
                _buildStep(context, 4, 'Builder tab',
                    'Create custom tickets'),
              ],
            ),
          ),

          SizedBox(height: FiftySpacing.xxl),

          // Navigation Hint
          FiftyCard(
            scanlineOnHover: false,
            backgroundColor: colorScheme.primaryContainer,
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: colorScheme.onPrimaryContainer),
                SizedBox(width: FiftySpacing.md),
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
        ],
      ),
    );
  }

  Widget _buildStep(
      BuildContext context, int number, String title, String description) {
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
        SizedBox(width: FiftySpacing.md),
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
              SizedBox(height: FiftySpacing.xs),
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
