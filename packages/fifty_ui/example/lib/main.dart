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
            title: 'CONTROLS',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ControlsPage()),
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
          _buildSection(
            context,
            title: 'LAYOUT',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LayoutPage()),
            ),
          ),
          _buildSection(
            context,
            title: 'NAVIGATION',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NavigationPage()),
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
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyLarge,
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
              FiftyButton(
                label: 'Outline',
                onPressed: () {},
                variant: FiftyButtonVariant.outline,
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
          const _SectionTitle('Trailing Icons'),
          Wrap(
            spacing: FiftySpacing.md,
            runSpacing: FiftySpacing.md,
            children: [
              FiftyButton(
                label: 'Get Started',
                onPressed: () {},
                trailingIcon: Icons.arrow_forward,
              ),
              FiftyButton(
                label: 'Download',
                onPressed: () {},
                variant: FiftyButtonVariant.secondary,
                icon: Icons.download,
              ),
              FiftyButton(
                label: 'Learn More',
                onPressed: () {},
                variant: FiftyButtonVariant.outline,
                trailingIcon: Icons.arrow_forward,
              ),
            ],
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
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Kinetic Brutalism'),
          const Text(
            'Hover over buttons to see effects',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          Wrap(
            spacing: FiftySpacing.md,
            runSpacing: FiftySpacing.md,
            children: [
              FiftyButton(
                label: 'GLITCH EFFECT',
                onPressed: () {},
                isGlitch: true,
              ),
              FiftyButton(
                label: 'SECONDARY',
                onPressed: () {},
                variant: FiftyButtonVariant.secondary,
              ),
              FiftyButton(
                label: 'GLITCH + DANGER',
                onPressed: () {},
                isGlitch: true,
                variant: FiftyButtonVariant.danger,
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

  // Form component states
  bool _switchValue = false;
  bool _notificationsEnabled = true;
  bool _darkMode = true;
  double _sliderValue = 50;
  double _volumeValue = 75;
  String? _selectedLanguage;
  String? _selectedPriority;

  // Checkbox states
  bool _checkbox1 = false;
  bool _checkbox2 = true;

  // Radio state
  String? _radioValue = 'option1';

  // Radio card state
  int _displayMode = 1;

  final _languages = [
    const FiftyDropdownItem(value: 'dart', label: 'Dart', icon: Icons.code),
    const FiftyDropdownItem(value: 'kotlin', label: 'Kotlin', icon: Icons.android),
    const FiftyDropdownItem(value: 'swift', label: 'Swift', icon: Icons.apple),
    const FiftyDropdownItem(value: 'rust', label: 'Rust', icon: Icons.memory),
  ];

  final _priorities = [
    const FiftyDropdownItem(value: 'p0', label: 'P0 - Critical'),
    const FiftyDropdownItem(value: 'p1', label: 'P1 - High'),
    const FiftyDropdownItem(value: 'p2', label: 'P2 - Medium'),
    const FiftyDropdownItem(value: 'p3', label: 'P3 - Low'),
  ];

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
          const SizedBox(height: FiftySpacing.lg),
          const FiftyTextField(
            hint: 'Search...',
            prefix: Icon(Icons.search),
            shape: FiftyTextFieldShape.rounded,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Terminal Styles'),
          const Text(
            'Advanced styling for terminal-like inputs',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          const FiftyTextField(
            label: 'Bottom Border Only',
            hint: 'Enter value',
            borderStyle: FiftyBorderStyle.bottom,
          ),
          const SizedBox(height: FiftySpacing.lg),
          const FiftyTextField(
            label: 'No Border',
            hint: 'Enter text',
            borderStyle: FiftyBorderStyle.none,
          ),
          const SizedBox(height: FiftySpacing.lg),
          const FiftyTextField(
            label: 'Chevron Prefix',
            hint: 'command',
            borderStyle: FiftyBorderStyle.bottom,
            prefixStyle: FiftyPrefixStyle.chevron,
          ),
          const SizedBox(height: FiftySpacing.lg),
          const FiftyTextField(
            label: 'Comment Prefix',
            hint: 'your comment',
            prefixStyle: FiftyPrefixStyle.comment,
          ),
          const SizedBox(height: FiftySpacing.lg),
          const FiftyTextField(
            label: 'Block Cursor',
            hint: 'Focus to see block cursor',
            borderStyle: FiftyBorderStyle.bottom,
            prefixStyle: FiftyPrefixStyle.chevron,
            cursorStyle: FiftyCursorStyle.block,
          ),
          const SizedBox(height: FiftySpacing.lg),
          const FiftyTextField(
            label: 'Underscore Cursor',
            hint: 'Focus to see underscore cursor',
            cursorStyle: FiftyCursorStyle.underscore,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Checkboxes'),
          const Text(
            'Selection controls with kinetic animation',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftyCheckbox(
            value: _checkbox1,
            onChanged: (value) => setState(() => _checkbox1 = value),
            label: 'Accept terms and conditions',
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftyCheckbox(
            value: _checkbox2,
            onChanged: (value) => setState(() => _checkbox2 = value),
            label: 'Subscribe to newsletter',
          ),
          const SizedBox(height: FiftySpacing.md),
          const FiftyCheckbox(
            value: false,
            onChanged: null,
            label: 'Disabled checkbox',
            enabled: false,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Radio Buttons'),
          const Text(
            'Mutually exclusive selection with animated dot',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftyRadio<String>(
            value: 'option1',
            groupValue: _radioValue,
            onChanged: (value) => setState(() => _radioValue = value),
            label: 'Option 1',
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftyRadio<String>(
            value: 'option2',
            groupValue: _radioValue,
            onChanged: (value) => setState(() => _radioValue = value),
            label: 'Option 2',
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftyRadio<String>(
            value: 'option3',
            groupValue: _radioValue,
            onChanged: (value) => setState(() => _radioValue = value),
            label: 'Option 3',
          ),
          const SizedBox(height: FiftySpacing.md),
          const FiftyRadio<String>(
            value: 'disabled',
            groupValue: null,
            onChanged: null,
            label: 'Disabled radio',
            enabled: false,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Radio Cards'),
          const Text(
            'Card-style radio selection for theme modes',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          Row(
            children: [
              Expanded(
                child: FiftyRadioCard<int>(
                  value: 0,
                  groupValue: _displayMode,
                  onChanged: (v) => setState(() => _displayMode = v ?? 0),
                  icon: Icons.light_mode,
                  label: 'Light',
                ),
              ),
              const SizedBox(width: FiftySpacing.md),
              Expanded(
                child: FiftyRadioCard<int>(
                  value: 1,
                  groupValue: _displayMode,
                  onChanged: (v) => setState(() => _displayMode = v ?? 1),
                  icon: Icons.dark_mode,
                  label: 'Dark',
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Switches'),
          const Text(
            'Kinetic toggle switches with snap animation',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftySwitch(
            value: _switchValue,
            onChanged: (value) => setState(() => _switchValue = value),
            label: 'Basic Switch',
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftySwitch(
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
            label: 'Enable Notifications',
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftySwitch(
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
            label: 'Dark Mode',
          ),
          const SizedBox(height: FiftySpacing.md),
          const Text(
            'Switch Sizes',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          Wrap(
            spacing: FiftySpacing.lg,
            runSpacing: FiftySpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FiftySwitch(
                value: _switchValue,
                onChanged: (value) => setState(() => _switchValue = value),
                size: FiftySwitchSize.small,
              ),
              FiftySwitch(
                value: _switchValue,
                onChanged: (value) => setState(() => _switchValue = value),
                size: FiftySwitchSize.medium,
              ),
              FiftySwitch(
                value: _switchValue,
                onChanged: (value) => setState(() => _switchValue = value),
                size: FiftySwitchSize.large,
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.md),
          const FiftySwitch(
            value: false,
            onChanged: null,
            label: 'Disabled Switch',
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Sliders'),
          const Text(
            'Brutalist range selectors with square thumb',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftySlider(
            value: _sliderValue,
            min: 0,
            max: 100,
            onChanged: (value) => setState(() => _sliderValue = value),
            label: 'Value',
            showLabel: true,
          ),
          const SizedBox(height: FiftySpacing.lg),
          FiftySlider(
            value: _volumeValue,
            min: 0,
            max: 100,
            onChanged: (value) => setState(() => _volumeValue = value),
            label: 'Volume',
            showLabel: true,
            labelBuilder: (value) => '${value.round()}%',
          ),
          const SizedBox(height: FiftySpacing.lg),
          FiftySlider(
            value: _sliderValue,
            min: 0,
            max: 100,
            divisions: 10,
            onChanged: (value) => setState(() => _sliderValue = value),
            label: 'With Divisions (steps of 10)',
          ),
          const SizedBox(height: FiftySpacing.lg),
          const FiftySlider(
            value: 50,
            min: 0,
            max: 100,
            onChanged: null,
            label: 'Disabled',
            enabled: false,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Dropdowns'),
          const Text(
            'Terminal-styled dropdown selectors',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftyDropdown<String>(
            items: _languages,
            value: _selectedLanguage,
            onChanged: (value) => setState(() => _selectedLanguage = value),
            label: 'Language',
            hint: 'Select a language',
          ),
          const SizedBox(height: FiftySpacing.lg),
          FiftyDropdown<String>(
            items: _priorities,
            value: _selectedPriority,
            onChanged: (value) => setState(() => _selectedPriority = value),
            label: 'Priority',
            hint: 'Select priority level',
          ),
          const SizedBox(height: FiftySpacing.lg),
          FiftyDropdown<String>(
            items: _languages,
            value: 'dart',
            onChanged: null,
            label: 'Disabled',
            enabled: false,
          ),
          const SizedBox(height: FiftySpacing.xl),
        ],
      ),
    );
  }
}

// ============================================================================
// CONTROLS PAGE
// ============================================================================

class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});

  @override
  State<ControlsPage> createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  String _period = 'daily';
  String _viewMode = 'grid';
  String _expandedValue = 'all';
  String _themeMode = 'dark';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CONTROLS')),
      body: ListView(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        children: [
          const _SectionTitle('Segmented Control'),
          const Text(
            'Pill-style segments with animated selection',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftySegmentedControl<String>(
            segments: const [
              FiftySegment(value: 'daily', label: 'Daily'),
              FiftySegment(value: 'weekly', label: 'Weekly'),
              FiftySegment(value: 'monthly', label: 'Monthly'),
            ],
            selected: _period,
            onChanged: (value) => setState(() => _period = value),
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Variants'),
          const Text(
            'Primary (cream/burgundy) and Secondary (slate/cream)',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Primary',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: FiftyColors.slateGrey,
                      ),
                    ),
                    const SizedBox(height: FiftySpacing.sm),
                    FiftySegmentedControl<String>(
                      segments: const [
                        FiftySegment(value: 'daily', label: 'Daily'),
                        FiftySegment(value: 'weekly', label: 'Weekly'),
                      ],
                      selected: _period,
                      onChanged: (value) => setState(() => _period = value),
                      variant: FiftySegmentedControlVariant.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Secondary',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: FiftyColors.slateGrey,
                      ),
                    ),
                    const SizedBox(height: FiftySpacing.sm),
                    FiftySegmentedControl<String>(
                      segments: const [
                        FiftySegment(value: 'light', label: 'Light', icon: Icons.light_mode),
                        FiftySegment(value: 'dark', label: 'Dark', icon: Icons.dark_mode),
                        FiftySegment(value: 'system', label: 'System', icon: Icons.settings_suggest),
                      ],
                      selected: _themeMode,
                      onChanged: (value) => setState(() => _themeMode = value),
                      variant: FiftySegmentedControlVariant.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('With Icons'),
          const Text(
            'Segments with leading icons',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftySegmentedControl<String>(
            segments: const [
              FiftySegment(value: 'grid', label: 'Grid', icon: Icons.grid_view),
              FiftySegment(value: 'list', label: 'List', icon: Icons.list),
            ],
            selected: _viewMode,
            onChanged: (value) => setState(() => _viewMode = value),
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Expanded Mode'),
          const Text(
            'Segments expand to fill available width',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftySegmentedControl<String>(
            segments: const [
              FiftySegment(value: 'all', label: 'All'),
              FiftySegment(value: 'active', label: 'Active'),
              FiftySegment(value: 'completed', label: 'Completed'),
            ],
            selected: _expandedValue,
            onChanged: (value) => setState(() => _expandedValue = value),
            expanded: true,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Disabled State'),
          const Text(
            'Non-interactive segmented control',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftySegmentedControl<String>(
            segments: const [
              FiftySegment(value: 'on', label: 'On'),
              FiftySegment(value: 'off', label: 'Off'),
            ],
            selected: 'on',
            onChanged: (value) {},
            enabled: false,
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
          const SizedBox(height: FiftySpacing.md),
          FiftyCard(
            hasTexture: true,
            hoverScale: 1.05,
            onTap: () {},
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HALFTONE TEXTURE',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyLarge,
                    fontWeight: FiftyTypography.medium,
                  ),
                ),
                SizedBox(height: FiftySpacing.xs),
                Text(
                  'Card with halftone overlay and 5% hover scale',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: FiftyColors.slateGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          const FiftyCard(
            hasTexture: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NON-INTERACTIVE TEXTURE',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyLarge,
                    fontWeight: FiftyTypography.medium,
                  ),
                ),
                SizedBox(height: FiftySpacing.xs),
                Text(
                  'Static card with halftone texture (no hover)',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: FiftyColors.slateGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Stat Cards'),
          const Text(
            'Metric display with trend indicators',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          const Row(
            children: [
              Expanded(
                child: FiftyStatCard(
                  label: 'Total Views',
                  value: '45.2k',
                  icon: Icons.visibility,
                  trend: FiftyStatTrend.up,
                  trendValue: '12%',
                ),
              ),
              SizedBox(width: FiftySpacing.md),
              Expanded(
                child: FiftyStatCard(
                  label: 'Revenue',
                  value: '\$12.5k',
                  icon: Icons.account_balance_wallet,
                  highlight: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Progress Card'),
          const Text(
            'Progress metrics with gradient bar',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          const FiftyProgressCard(
            icon: Icons.trending_up,
            title: 'Weekly Goal',
            progress: 0.75,
            subtitle: '12 sales remaining to reach target',
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('List Tiles'),
          const Text(
            'Transaction-style list items',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          FiftyCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                FiftyListTile(
                  leadingIcon: Icons.subscriptions,
                  leadingIconColor: Colors.blue,
                  leadingIconBackgroundColor: Colors.blue.withValues(alpha: 0.15),
                  title: 'Subscription',
                  subtitle: 'Adobe Creative Cloud',
                  trailingText: '-\$54.00',
                  trailingSubtext: 'Today',
                  showDivider: true,
                ),
                FiftyListTile(
                  leadingIcon: Icons.arrow_downward,
                  leadingIconColor: FiftyColors.hunterGreen,
                  leadingIconBackgroundColor: FiftyColors.hunterGreen.withValues(alpha: 0.15),
                  title: 'Deposit',
                  subtitle: 'Freelance Work',
                  trailingText: '+\$850.00',
                  trailingTextColor: FiftyColors.hunterGreen,
                  trailingSubtext: 'Yesterday',
                ),
              ],
            ),
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
          const SizedBox(height: FiftySpacing.md),
          const Text(
            'Factory Constructors',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          Wrap(
            spacing: FiftySpacing.sm,
            runSpacing: FiftySpacing.sm,
            children: [
              FiftyBadge.tech('FLUTTER'),
              FiftyBadge.tech('DART'),
              FiftyBadge.status('ONLINE'),
              FiftyBadge.status('CONNECTED'),
              FiftyBadge.ai('IGRIS'),
              FiftyBadge.ai('AGENT'),
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
              FiftyAvatar(fallbackText: 'XY', size: 48, borderColor: FiftyColors.burgundy),
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
                color: FiftyColors.hunterGreen,
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
          const SizedBox(height: FiftySpacing.md),
          const Text(
            'Sequence Mode',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Default sequence (uses built-in messages)
              FiftyLoadingIndicator(
                style: FiftyLoadingStyle.sequence,
              ),
              SizedBox(height: FiftySpacing.md),
              // Custom sequence list
              FiftyLoadingIndicator(
                style: FiftyLoadingStyle.sequence,
                color: FiftyColors.hunterGreen,
                sequences: [
                  '> BOOTING SYSTEM...',
                  '> LOADING MODULES...',
                  '> CONNECTING TO API...',
                  '> READY',
                ],
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Code Block'),
          const Text(
            'Terminal-style code display with syntax highlighting',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          const FiftyCodeBlock(
            code: '''void main() {
  print('Hello, Fifty!');

  // Initialize the app
  final app = FiftyApp();
  app.run();
}''',
            language: 'dart',
          ),
          const SizedBox(height: FiftySpacing.lg),
          const Text(
            'Without Line Numbers',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          const FiftyCodeBlock(
            code: 'final greeting = "Welcome to Fifty UI";',
            language: 'dart',
            showLineNumbers: false,
          ),
          const SizedBox(height: FiftySpacing.lg),
          const Text(
            'Without Copy Button',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          const FiftyCodeBlock(
            code: 'npm install fifty-ui',
            language: 'plain',
            copyButton: false,
          ),
          const SizedBox(height: FiftySpacing.lg),
          const Text(
            'With Max Height (Scrollable)',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          const FiftyCodeBlock(
            code: '''class FiftyWidget extends StatelessWidget {
  const FiftyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('Fifty UI'),
    );
  }
}

// More code to demonstrate scrolling...
class AnotherWidget extends StatefulWidget {
  const AnotherWidget({super.key});

  @override
  State<AnotherWidget> createState() => _AnotherWidgetState();
}''',
            language: 'dart',
            maxHeight: 150,
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
// LAYOUT PAGE
// ============================================================================

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LAYOUT')),
      body: ListView(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        children: [
          const _SectionTitle('Hero Text'),
          const Text(
            'Monument headers with Manrope font',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          const FiftyHero(
            text: 'Display Size',
            size: FiftyHeroSize.display,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('H1 Size'),
          const SizedBox(height: FiftySpacing.md),
          const FiftyHero(
            text: 'H1 Headline',
            size: FiftyHeroSize.h1,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('H2 Size'),
          const SizedBox(height: FiftySpacing.md),
          const FiftyHero(
            text: 'H2 Section Header',
            size: FiftyHeroSize.h2,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('With Glitch Effect'),
          const Text(
            'Kinetic glitch animation on mount',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          const FiftyHero(
            text: 'Glitch Hero',
            size: FiftyHeroSize.h1,
            glitchOnMount: true,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('With Gradient'),
          const Text(
            'Custom gradient fill for dramatic effect',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          const FiftyHero(
            text: 'Gradient Text',
            size: FiftyHeroSize.h1,
            gradient: LinearGradient(
              colors: [FiftyColors.burgundy, FiftyColors.hunterGreen],
            ),
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Hero Section'),
          const Text(
            'Title with subtitle combo',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          const FiftyHeroSection(
            title: 'Fifty UI',
            subtitle: 'Design System v2 - Kinetic Brutalism',
            glitchOnMount: true,
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Left Aligned Section'),
          const SizedBox(height: FiftySpacing.md),
          const FiftyHeroSection(
            title: 'Welcome',
            subtitle: 'Build beautiful interfaces with confidence',
            titleSize: FiftyHeroSize.h1,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// NAVIGATION PAGE
// ============================================================================

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _pillIndex = 0;
  int _standardIndex = 1;
  int _textOnlyIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NAVIGATION')),
      body: ListView(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        children: [
          const _SectionTitle('NavBar - Pill Style'),
          const Text(
            'Dynamic Island inspired with glassmorphism',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: FiftyColors.surfaceDark,
              borderRadius: FiftyRadii.lgRadius,
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  bottom: FiftySpacing.lg,
                  left: 0,
                  right: 0,
                  child: FiftyNavBar(
                    items: const [
                      FiftyNavItem(label: 'Home', icon: Icons.home),
                      FiftyNavItem(label: 'Search', icon: Icons.search),
                      FiftyNavItem(label: 'Profile', icon: Icons.person),
                    ],
                    selectedIndex: _pillIndex,
                    onItemSelected: (index) => setState(() => _pillIndex = index),
                    style: FiftyNavBarStyle.pill,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('NavBar - Standard Style'),
          const Text(
            'Rectangular with standard border radius',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: FiftyColors.surfaceDark,
              borderRadius: FiftyRadii.lgRadius,
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  bottom: FiftySpacing.lg,
                  left: 0,
                  right: 0,
                  child: FiftyNavBar(
                    items: const [
                      FiftyNavItem(label: 'Dashboard', icon: Icons.dashboard),
                      FiftyNavItem(label: 'Analytics', icon: Icons.analytics),
                      FiftyNavItem(label: 'Reports', icon: Icons.description),
                      FiftyNavItem(label: 'Settings', icon: Icons.settings),
                    ],
                    selectedIndex: _standardIndex,
                    onItemSelected: (index) => setState(() => _standardIndex = index),
                    style: FiftyNavBarStyle.standard,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FiftySpacing.xl),
          const _SectionTitle('Text-Only (No Icons)'),
          const Text(
            'Label-only navigation items',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: FiftyColors.surfaceDark,
              borderRadius: FiftyRadii.lgRadius,
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  bottom: FiftySpacing.lg,
                  left: 0,
                  right: 0,
                  child: FiftyNavBar(
                    items: const [
                      FiftyNavItem(label: 'Today'),
                      FiftyNavItem(label: 'Week'),
                      FiftyNavItem(label: 'Month'),
                      FiftyNavItem(label: 'Year'),
                    ],
                    selectedIndex: _textOnlyIndex,
                    onItemSelected: (index) => setState(() => _textOnlyIndex = index),
                    style: FiftyNavBarStyle.pill,
                    height: 44,
                  ),
                ),
              ],
            ),
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
          fontFamily: FiftyTypography.fontFamily,
          fontSize: FiftyTypography.bodySmall,
          fontWeight: FiftyTypography.medium,
          color: FiftyColors.slateGrey,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
