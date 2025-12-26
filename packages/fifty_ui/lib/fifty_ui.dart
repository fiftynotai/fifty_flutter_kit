/// FDL-styled Flutter components for the fifty.dev ecosystem.
///
/// This package provides a comprehensive set of widgets that follow the
/// Fifty Design Language (FDL) specification, built on top of `fifty_tokens`
/// and `fifty_theme`.
///
/// All components feature:
/// - Crimson glow focus states
/// - Zero elevation (no drop shadows)
/// - Motion animations using FDL timing tokens
/// - Dark-first design
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
/// - [FiftyButton] - Primary action button with variants
/// - [FiftyIconButton] - Circular icon button
///
/// ### Inputs
/// - [FiftyTextField] - Text input with focus glow
/// - [FiftySwitch] - Kinetic toggle switch
/// - [FiftySlider] - Brutalist range slider
/// - [FiftyDropdown] - Terminal-styled dropdown selector
///
/// ### Containers
/// - [FiftyCard] - Card container with optional tap interaction
///
/// ### Display
/// - [FiftyChip] - Tag/label component
/// - [FiftyDivider] - Themed divider
/// - [FiftyDataSlate] - Terminal-style key-value display
/// - [FiftyBadge] - Status indicator
/// - [FiftyAvatar] - User avatar
/// - [FiftyProgressBar] - Linear progress indicator
/// - [FiftyLoadingIndicator] - FDL-compliant text-based loading indicator
///
/// ### Feedback
/// - [FiftySnackbar] - Toast notification
/// - [FiftyDialog] - Modal dialog
/// - [FiftyTooltip] - Hover tooltip
///
/// ### Organisms
/// - [FiftyNavBar] - Floating navigation bar with glassmorphism
/// - [FiftyHero] - Dramatic headline text with Monument Extended font
///
/// ### Molecules
/// - [FiftyCodeBlock] - Terminal-style code display with syntax highlighting
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
