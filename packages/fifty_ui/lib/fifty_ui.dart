/// FDL v2 styled Flutter components for the fifty.dev ecosystem.
///
/// This package provides a comprehensive set of widgets that follow the
/// Fifty Design Language v2 specification, built on top of `fifty_tokens`
/// and `fifty_theme`.
///
/// All components feature:
/// - Burgundy primary color (FDL v2 brand)
/// - Mode-aware colors (dark and light mode support)
/// - Motion animations using FDL timing tokens
/// - WCAG 2.1 AA compliant accessibility
/// - Manrope font family
///
/// ## Getting Started
///
/// 1. Add the package to your `pubspec.yaml`:
/// ```yaml
/// dependencies:
///   fifty_ui:
///     path: ../fifty_ui
///   fifty_theme:
///     path: ../fifty_theme
/// ```
///
/// 2. Wrap your app with the Fifty theme:
/// ```dart
/// import 'package:fifty_theme/fifty_theme.dart';
/// import 'package:fifty_ui/fifty_ui.dart';
///
/// MaterialApp(
///   theme: FiftyTheme.dark(),
///   home: MyApp(),
/// );
/// ```
///
/// 3. Use the components:
/// ```dart
/// FiftyButton(
///   label: 'DEPLOY',
///   onPressed: () => handleDeploy(),
///   variant: FiftyButtonVariant.primary,
/// )
/// ```
///
/// ## Components
///
/// ### Buttons
/// - [FiftyButton] - Primary action button with variants (heights: 36/48/56)
/// - [FiftyIconButton] - Circular icon button
///
/// ### Inputs
/// - [FiftyTextField] - Text input with 48px height and xl radius
/// - [FiftySwitch] - Kinetic toggle (ON = slateGrey, NOT primary!)
/// - [FiftySlider] - Range slider with mode-aware styling
/// - [FiftyDropdown] - Dropdown selector with xl radius
/// - [FiftyCheckbox] - Multi-select boolean control with v2 styling
/// - [FiftyRadio] - Single-select option control with v2 styling
///
/// ### Controls
/// - [FiftySegmentedControl] - Pill-style segmented control (NEW in v2)
///
/// ### Containers
/// - [FiftyCard] - Card container with xxl/xxxl radius and md shadow
///
/// ### Display
/// - [FiftyChip] - Tag/label component
/// - [FiftyDivider] - Themed divider
/// - [FiftyDataSlate] - Key-value display panel
/// - [FiftyBadge] - Status indicator
/// - [FiftyAvatar] - User avatar
/// - [FiftyProgressBar] - Linear progress indicator
/// - [FiftyStatCard] - Metric/KPI display card
/// - [FiftyListTile] - List item with icon, title, trailing content
/// - [FiftyLoadingIndicator] - Text-based loading indicator
///
/// ### Feedback
/// - [FiftySnackbar] - Toast notification
/// - [FiftyDialog] - Modal dialog with xxxl radius
/// - [FiftyTooltip] - Hover tooltip
///
/// ### Organisms
/// - [FiftyNavBar] - Floating navigation bar with glassmorphism
/// - [FiftyHero] - Dramatic headline text with Manrope font
///
/// ### Molecules
/// - [FiftyCodeBlock] - Code display with syntax highlighting
///
/// ### Utils
/// - [GlowContainer] - Reusable glow animation wrapper
/// - [KineticEffect] - Hover/press scale animation wrapper
/// - [GlitchEffect] - RGB chromatic aberration effect
/// - [HalftonePainter] - CustomPainter for halftone dot patterns
/// - [HalftoneOverlay] - Widget wrapper for halftone textures
library;

// Buttons
export 'src/buttons/fifty_button.dart';
export 'src/buttons/fifty_icon_button.dart';

// Inputs
export 'src/inputs/fifty_dropdown.dart';
export 'src/inputs/fifty_slider.dart';
export 'src/inputs/fifty_switch.dart';
export 'src/inputs/fifty_text_field.dart';
export 'src/inputs/fifty_checkbox.dart';
export 'src/inputs/fifty_radio.dart';
export 'src/inputs/fifty_radio_card.dart';

// Controls (NEW in v2)
export 'src/controls/fifty_segmented_control.dart';

// Containers
export 'src/containers/fifty_card.dart';

// Display
export 'src/display/fifty_avatar.dart';
export 'src/display/fifty_badge.dart';
export 'src/display/fifty_chip.dart';
export 'src/display/fifty_data_slate.dart';
export 'src/display/fifty_divider.dart';
export 'src/display/fifty_loading_indicator.dart';
export 'src/display/fifty_progress_bar.dart';
export 'src/display/fifty_stat_card.dart';
export 'src/display/fifty_list_tile.dart';
export 'src/display/fifty_progress_card.dart';

// Feedback
export 'src/feedback/fifty_dialog.dart';
export 'src/feedback/fifty_snackbar.dart';
export 'src/feedback/fifty_tooltip.dart';

// Organisms
export 'src/organisms/fifty_hero.dart';
export 'src/organisms/fifty_nav_bar.dart';

// Molecules
export 'src/molecules/fifty_code_block.dart';

// Utils
export 'src/utils/glitch_effect.dart';
export 'src/utils/glow_container.dart';
export 'src/utils/halftone_painter.dart';
export 'src/utils/kinetic_effect.dart';
