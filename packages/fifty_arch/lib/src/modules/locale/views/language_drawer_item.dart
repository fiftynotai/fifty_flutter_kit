import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/locale/controllers/localization_view_model.dart';
import '/src/modules/locale/views/language_dialog.dart';

/// Language Protocol drawer item - FDL Kinetic Brutalism styled.
///
/// Displays the current language and allows changing it via a dialog.
/// Uses the Fifty Design Language (FDL) with Orbital Command space theme.
///
/// ## Features:
/// - Gunmetal background on hover
/// - hyperChrome icons
/// - terminalWhite text
/// - Language indicator in JetBrains Mono
///
/// ## Usage:
/// ```dart
/// Drawer(
///   child: ListView(
///     children: [
///       LanguageDrawerItem(),
///     ],
///   ),
/// )
/// ```
class LanguageDrawerItem extends GetWidget<LocalizationViewModel> {
  /// Creates a [LanguageDrawerItem].
  const LanguageDrawerItem({super.key});

  /// Gets the flag emoji for a given country code.
  String _getFlagEmoji(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'GB':
        return '\u{1F1EC}\u{1F1E7}'; // UK flag
      case 'AE':
        return '\u{1F1E6}\u{1F1EA}'; // UAE flag
      default:
        return '\u{1F310}'; // Globe
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(
      () => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLanguageDialog(context),
          splashColor: colorScheme.primary.withValues(alpha: 0.1),
          highlightColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.lg,
              vertical: FiftySpacing.md,
            ),
            child: Row(
              children: [
                // Leading icon
                Container(
                  padding: const EdgeInsets.all(FiftySpacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(FiftyRadii.standard),
                    border: Border.all(
                      color: FiftyColors.border,
                    ),
                  ),
                  child: const Icon(
                    Icons.language,
                    color: FiftyColors.hyperChrome,
                    size: 20,
                  ),
                ),
                const SizedBox(width: FiftySpacing.md),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'LANGUAGE PROTOCOL',
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamilyMono,
                          fontSize: FiftyTypography.mono,
                          fontWeight: FiftyTypography.medium,
                          color: colorScheme.onSurface,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: FiftySpacing.xs),
                      Text(
                        '${_getFlagEmoji(controller.language.countryCode)} ${controller.language.name}',
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamilyMono,
                          fontSize: FiftyTypography.mono,
                          color: FiftyColors.hyperChrome,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Trailing chevron
                const Icon(
                  Icons.chevron_right,
                  color: FiftyColors.hyperChrome,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows the language picker dialog.
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LanguagePickerDialog(),
    );
  }
}
