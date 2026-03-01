import 'package:fifty_connectivity/fifty_connectivity.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Live showcase of the [ConnectivityCheckerSplash] widget.
///
/// Shows a visual preview of the splash screen and its configuration.
class SplashDemoScreen extends StatelessWidget {
  /// Creates the splash demo screen.
  const SplashDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('ConnectivityCheckerSplash')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(FiftySpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Splash visual preview
            FiftyCard(
              padding: EdgeInsets.all(FiftySpacing.xxl),
              child: SizedBox(
                height: 280,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo placeholder
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: FiftyRadii.lgRadius,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.wifi,
                            size: 48,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: FiftySpacing.xl),

                      // Loading indicator
                      const FiftyLoadingIndicator(
                        text: 'Checking connectivity',
                        style: FiftyLoadingStyle.dots,
                        size: FiftyLoadingSize.medium,
                      ),
                      SizedBox(height: FiftySpacing.lg),

                      // Subtitle
                      Text(
                        'Gates app entry on connectivity',
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.bodySmall,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: FiftySpacing.xl),

            // Splash configuration
            FiftyDataSlate(
              title: 'SPLASH CONFIG',
              data: {
                'Next Route': ConnectivityConfig.defaultNextRoute,
                'Delay': '${ConnectivityConfig.splashDelaySeconds}s',
                'Navigation': ConnectivityConfig.navigateOff != null
                    ? 'Configured'
                    : 'Not set',
                'Logo': ConnectivityConfig.logoBuilder != null
                    ? 'Custom'
                    : 'Default placeholder',
              },
            ),
            SizedBox(height: FiftySpacing.lg),

            // Logo priority
            const FiftySectionHeader(title: 'LOGO PRIORITY'),
            SizedBox(height: FiftySpacing.md),
            _buildPriorityItem(
              context,
              number: '1',
              title: 'Widget logoBuilder',
              active: false,
            ),
            SizedBox(height: FiftySpacing.sm),
            _buildPriorityItem(
              context,
              number: '2',
              title: 'ConnectivityConfig.logoBuilder',
              active: ConnectivityConfig.logoBuilder != null,
            ),
            SizedBox(height: FiftySpacing.sm),
            _buildPriorityItem(
              context,
              number: '3',
              title: 'Default placeholder',
              active: ConnectivityConfig.logoBuilder == null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityItem(
    BuildContext context, {
    required String number,
    required String title,
    required bool active,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: active
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyMedium,
                  fontWeight: FiftyTypography.bold,
                  color: active
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          SizedBox(width: FiftySpacing.md),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyMedium,
                fontWeight: active ? FiftyTypography.bold : FiftyTypography.regular,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          if (active)
            FiftyBadge.status('ACTIVE'),
        ],
      ),
    );
  }
}
