import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FiftyUIExampleApp());
}

/// Example gallery app demonstrating all fifty_ui components.
class FiftyUIExampleApp extends StatelessWidget {
  const FiftyUIExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifty UI Gallery',
      theme: FiftyTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: const GalleryHome(),
    );
  }
}

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIFTY UI GALLERY'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        children: [
          _buildSection(
            context,
            title: 'BUTTONS',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ButtonsPage()),
            ),
          ),
          _buildSection(
            context,
            title: 'INPUTS',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InputsPage()),
            ),
          ),
          _buildSection(
            context,
            title: 'DISPLAY',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DisplayPage()),
            ),
          ),
          _buildSection(
            context,
            title: 'FEEDBACK',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FeedbackPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FiftySpacing.md),
      child: FiftyCard(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.body,
                fontWeight: FiftyTypography.medium,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// BUTTONS PAGE
// ============================================================================

class ButtonsPage extends StatefulWidget {
  const ButtonsPage({super.key});

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BUTTONS')),
      body: ListView(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        children: [
          const _SectionTitle('Button Variants'),
          Wrap(
            spacing: FiftySpacing.md,
            runSpacing: FiftySpacing.md,
            children: [
              FiftyButton(
                label: 'Primary',
                onPressed: () {},
                variant: FiftyButtonVariant.primary,
              ),
              FiftyButton(
                label: 'Secondary',
                onPressed: () {},
                variant: FiftyButtonVariant.secondary,
              ),
              FiftyButton(
                label: 'Ghost',
                onPressed: () {},
                variant: FiftyButtonVariant.ghost,
              ),
              FiftyButton(
                label: 'Danger',
                onPressed: () {},
                variant: FiftyButtonVariant.danger,
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Button Sizes'),
          Wrap(
            spacing: FiftySpacing.md,
            runSpacing: FiftySpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FiftyButton(
                label: 'Small',
                onPressed: () {},
                size: FiftyButtonSize.small,
              ),
              FiftyButton(
                label: 'Medium',
                onPressed: () {},
                size: FiftyButtonSize.medium,
              ),
              FiftyButton(
                label: 'Large',
                onPressed: () {},
                size: FiftyButtonSize.large,
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Button States'),
          Wrap(
            spacing: FiftySpacing.md,
            runSpacing: FiftySpacing.md,
            children: [
              FiftyButton(
                label: 'With Icon',
                onPressed: () {},
                icon: Icons.rocket_launch,
              ),
              const FiftyButton(
                label: 'Disabled',
                onPressed: null,
              ),
              FiftyButton(
                label: 'Loading',
                onPressed: () {},
                loading: _loading,
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftyButton(
            label: _loading ? 'Stop Loading' : 'Start Loading',
            onPressed: () => setState(() => _loading = !_loading),
            variant: FiftyButtonVariant.secondary,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Icon Buttons'),
          Wrap(
            spacing: FiftySpacing.md,
            runSpacing: FiftySpacing.md,
            children: [
              FiftyIconButton(
                icon: Icons.settings,
                tooltip: 'Settings',
                onPressed: () {},
                variant: FiftyIconButtonVariant.primary,
              ),
              FiftyIconButton(
                icon: Icons.edit,
                tooltip: 'Edit',
                onPressed: () {},
                variant: FiftyIconButtonVariant.secondary,
              ),
              FiftyIconButton(
                icon: Icons.delete,
                tooltip: 'Delete',
                onPressed: () {},
                variant: FiftyIconButtonVariant.ghost,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// INPUTS PAGE
// ============================================================================

class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  final _emailController = TextEditingController();
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      if (email.isEmpty) {
        _emailError = 'Email is required';
      } else if (!email.contains('@')) {
        _emailError = 'Please enter a valid email';
      } else {
        _emailError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('INPUTS')),
      body: ListView(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        children: [
          const _SectionTitle('Text Field'),
          FiftyTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email address',
            prefix: const Icon(Icons.email),
            errorText: _emailError,
            onChanged: (_) => _validateEmail(),
          ),
          const SizedBox(height: FiftySpacing.lg),
          const FiftyTextField(
            label: 'Password',
            hint: 'Enter your password',
            prefix: Icon(Icons.lock),
            obscureText: true,
          ),
          const SizedBox(height: FiftySpacing.lg),
          const FiftyTextField(
            label: 'Disabled',
            hint: 'This field is disabled',
            enabled: false,
          ),
          const SizedBox(height: FiftySpacing.lg),
          const FiftyTextField(
            label: 'Multiline',
            hint: 'Enter a longer message...',
            maxLines: 4,
          ),
          const SizedBox(height: FiftySpacing.lg),
          const FiftyTextField(
            label: 'Terminal Style',
            hint: 'Enter command',
            terminalStyle: true,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DISPLAY PAGE
// ============================================================================

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  double _progress = 0.65;
  bool _selectedCard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DISPLAY')),
      body: ListView(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        children: [
          const _SectionTitle('Cards'),
          FiftyCard(
            onTap: () => setState(() => _selectedCard = !_selectedCard),
            selected: _selectedCard,
            child: const Text('Tap to select this card'),
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Chips'),
          Wrap(
            spacing: FiftySpacing.sm,
            runSpacing: FiftySpacing.sm,
            children: [
              const FiftyChip(label: 'Default'),
              const FiftyChip(
                label: 'Success',
                variant: FiftyChipVariant.success,
                selected: true,
              ),
              const FiftyChip(
                label: 'Warning',
                variant: FiftyChipVariant.warning,
              ),
              FiftyChip(
                label: 'Deletable',
                onDeleted: () {},
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Badges'),
          const Wrap(
            spacing: FiftySpacing.sm,
            runSpacing: FiftySpacing.sm,
            children: [
              FiftyBadge(label: 'Primary'),
              FiftyBadge(label: 'Live', variant: FiftyBadgeVariant.success, showGlow: true),
              FiftyBadge(label: 'Warning', variant: FiftyBadgeVariant.warning),
              FiftyBadge(label: 'Error', variant: FiftyBadgeVariant.error),
              FiftyBadge(label: 'Neutral', variant: FiftyBadgeVariant.neutral),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Avatars'),
          const Wrap(
            spacing: FiftySpacing.md,
            runSpacing: FiftySpacing.md,
            children: [
              FiftyAvatar(fallbackText: 'JD', size: 32),
              FiftyAvatar(fallbackText: 'AB', size: 40),
              FiftyAvatar(fallbackText: 'XY', size: 48, borderColor: FiftyColors.crimsonPulse),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Progress Bar'),
          FiftyProgressBar(
            value: _progress,
            label: 'Uploading',
            showPercentage: true,
          ),
          const SizedBox(height: FiftySpacing.md),
          Slider(
            value: _progress,
            onChanged: (value) => setState(() => _progress = value),
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Loading Indicator'),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FDL-compliant text-based loading indicators
              FiftyLoadingIndicator(size: FiftyLoadingSize.small),
              SizedBox(height: FiftySpacing.md),
              FiftyLoadingIndicator(size: FiftyLoadingSize.medium),
              SizedBox(height: FiftySpacing.md),
              FiftyLoadingIndicator(
                size: FiftyLoadingSize.large,
                color: FiftyColors.igrisGreen,
              ),
              SizedBox(height: FiftySpacing.md),
              // Custom loading text
              FiftyLoadingIndicator(text: 'PROCESSING'),
              SizedBox(height: FiftySpacing.md),
              // Static style (no animation)
              FiftyLoadingIndicator(
                text: 'UPLOADING',
                style: FiftyLoadingStyle.static,
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Data Slate'),
          const FiftyDataSlate(
            title: 'System Status',
            data: {
              'CPU': '45%',
              'Memory': '8.2 GB / 16 GB',
              'Disk': '234 GB free',
              'Network': 'Connected',
              'Uptime': '72h 14m 32s',
            },
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Dividers'),
          const FiftyDivider(),
          const SizedBox(height: FiftySpacing.md),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Left'),
              SizedBox(width: FiftySpacing.md),
              SizedBox(height: 20, child: FiftyDivider(vertical: true)),
              SizedBox(width: FiftySpacing.md),
              Text('Right'),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FEEDBACK PAGE
// ============================================================================

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FEEDBACK')),
      body: ListView(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        children: [
          const _SectionTitle('Snackbars'),
          Wrap(
            spacing: FiftySpacing.md,
            runSpacing: FiftySpacing.md,
            children: [
              FiftyButton(
                label: 'Info',
                variant: FiftyButtonVariant.secondary,
                onPressed: () => FiftySnackbar.show(
                  context,
                  message: 'This is an info message',
                  variant: FiftySnackbarVariant.info,
                ),
              ),
              FiftyButton(
                label: 'Success',
                variant: FiftyButtonVariant.secondary,
                onPressed: () => FiftySnackbar.show(
                  context,
                  message: 'Operation completed successfully!',
                  variant: FiftySnackbarVariant.success,
                ),
              ),
              FiftyButton(
                label: 'Warning',
                variant: FiftyButtonVariant.secondary,
                onPressed: () => FiftySnackbar.show(
                  context,
                  message: 'Please review your changes',
                  variant: FiftySnackbarVariant.warning,
                ),
              ),
              FiftyButton(
                label: 'Error',
                variant: FiftyButtonVariant.secondary,
                onPressed: () => FiftySnackbar.show(
                  context,
                  message: 'An error occurred',
                  variant: FiftySnackbarVariant.error,
                ),
              ),
              FiftyButton(
                label: 'With Action',
                variant: FiftyButtonVariant.secondary,
                onPressed: () => FiftySnackbar.show(
                  context,
                  message: 'File deleted',
                  variant: FiftySnackbarVariant.info,
                  actionLabel: 'Undo',
                  onAction: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Dialogs'),
          FiftyButton(
            label: 'Show Dialog',
            onPressed: () => showFiftyDialog(
              context: context,
              builder: (context) => FiftyDialog(
                title: 'Confirm Action',
                content: const Text(
                  'Are you sure you want to proceed with this action? '
                  'This cannot be undone.',
                ),
                actions: [
                  FiftyButton(
                    label: 'Cancel',
                    variant: FiftyButtonVariant.ghost,
                    onPressed: () => Navigator.pop(context),
                  ),
                  FiftyButton(
                    label: 'Confirm',
                    onPressed: () {
                      Navigator.pop(context);
                      FiftySnackbar.show(
                        context,
                        message: 'Action confirmed!',
                        variant: FiftySnackbarVariant.success,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Tooltips'),
          Wrap(
            spacing: FiftySpacing.md,
            runSpacing: FiftySpacing.md,
            children: [
              FiftyTooltip(
                message: 'This is a tooltip',
                child: FiftyButton(
                  label: 'Hover Me',
                  variant: FiftyButtonVariant.secondary,
                  onPressed: () {},
                ),
              ),
              const FiftyTooltip(
                message: 'Settings configuration',
                child: FiftyIconButton(
                  icon: Icons.settings,
                  tooltip: 'Settings',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HELPERS
// ============================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FiftySpacing.md),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.mono,
          fontWeight: FiftyTypography.medium,
          color: FiftyColors.hyperChrome,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
