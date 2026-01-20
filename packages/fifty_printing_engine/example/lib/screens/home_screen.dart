import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Printing Engine Example',
          style: TextStyle(color: FiftyColors.terminalWhite),
        ),
        backgroundColor: FiftyColors.voidBlack,
      ),
      body: ListView(
        padding: EdgeInsets.all(FiftySpacing.lg),
        children: [
          // Header
          FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.lg),
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Printing Engine',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: FiftyColors.terminalWhite,
                      ),
                ),
                SizedBox(height: FiftySpacing.sm),
                Text(
                  'Production-grade Flutter package for multi-printer ESC/POS printing',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: FiftyColors.hyperChrome,
                      ),
                ),
                SizedBox(height: FiftySpacing.lg),
                Text(
                  'Version: 1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: FiftyColors.hyperChrome,
                      ),
                ),
              ],
            ),
          ),

          SizedBox(height: FiftySpacing.xxl),

          // Features
          Text(
            'Features',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: FiftyColors.terminalWhite,
                ),
          ),
          SizedBox(height: FiftySpacing.md),

          _buildFeatureCard(
            context,
            icon: Icons.print,
            title: 'Multi-Printer Management',
            description: 'Register and manage multiple Bluetooth and WiFi printers simultaneously',
            color: FiftyColors.crimsonPulse,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.route,
            title: 'Flexible Routing Strategies',
            description: 'Print to all, select per print, or use role-based routing',
            color: FiftyColors.success,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.bluetooth,
            title: 'Bluetooth & WiFi Support',
            description: 'Works with thermal printers over Bluetooth and network printers',
            color: FiftyColors.crimsonPulse,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.monitor_heart,
            title: 'Status Monitoring & Health Checks',
            description: 'Real-time printer status updates and periodic health monitoring',
            color: FiftyColors.warning,
          ),

          _buildFeatureCard(
            context,
            icon: Icons.check_circle,
            title: 'Result Tracking',
            description: 'Per-printer success/failure details with error messages',
            color: FiftyColors.success,
          ),

          SizedBox(height: FiftySpacing.xxl),

          // Quick Start
          Text(
            'Quick Start',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: FiftyColors.terminalWhite,
                ),
          ),
          SizedBox(height: FiftySpacing.md),

          FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.lg),
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStep(context, 1, 'Go to Printers tab', 'Add your Bluetooth or WiFi printer'),
                Divider(height: FiftySpacing.xxl, color: FiftyColors.border),
                _buildStep(context, 2, 'Configure routing', 'Choose printing mode and role mappings'),
                Divider(height: FiftySpacing.xxl, color: FiftyColors.border),
                _buildStep(context, 3, 'Test Print tab', 'Try different printing scenarios'),
                Divider(height: FiftySpacing.xxl, color: FiftyColors.border),
                _buildStep(context, 4, 'Builder tab', 'Create custom tickets'),
              ],
            ),
          ),

          SizedBox(height: FiftySpacing.xxl),

          // Navigation Hint
          FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.lg),
            backgroundColor: FiftyColors.crimsonPulse.withValues(alpha: 0.1),
            scanlineOnHover: false,
            child: Row(
              children: [
                Icon(Icons.info_outline, color: FiftyColors.crimsonPulse),
                SizedBox(width: FiftySpacing.md),
                Expanded(
                  child: Text(
                    'Use the bottom navigation to explore different features',
                    style: TextStyle(
                      color: FiftyColors.terminalWhite,
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

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return FiftyCard(
      margin: EdgeInsets.only(bottom: FiftySpacing.md),
      padding: EdgeInsets.all(FiftySpacing.md),
      scanlineOnHover: false,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: FiftySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: FiftyColors.terminalWhite,
                  ),
                ),
                SizedBox(height: FiftySpacing.xs),
                Text(
                  description,
                  style: TextStyle(
                    color: FiftyColors.hyperChrome,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, int number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: FiftyColors.crimsonPulse,
          child: Text(
            '$number',
            style: TextStyle(
              color: FiftyColors.terminalWhite,
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: FiftyColors.terminalWhite,
                ),
              ),
              SizedBox(height: FiftySpacing.xs),
              Text(
                description,
                style: TextStyle(
                  color: FiftyColors.hyperChrome,
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
