import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/route_manager.dart';
import '../controllers/localization_view_model.dart';
import '../data/models/language_model.dart';

/// Language Protocol Dialog - FDL Kinetic Brutalism styled language selector.
///
/// A dialog widget to allow the user to select a communication language.
/// Uses the Fifty Design Language (FDL) with Orbital Command space theme.
///
/// ## Features:
/// - Gunmetal background with hyperChrome border
/// - "LANGUAGE PROTOCOL" title in Monument Extended
/// - Language chips with crimsonPulse selection accent
/// - FiftyButton for confirm/cancel actions
///
/// ## Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => const LanguagePickerDialog(),
/// );
/// ```
class LanguagePickerDialog extends GetView<LocalizationViewModel> {
  const LanguagePickerDialog({super.key});

  /// Gets the flag emoji for a given language code.
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

    return Dialog(
      backgroundColor: colorScheme.surfaceContainerHighest,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FiftyRadii.standard),
        side: const BorderSide(
          color: FiftyColors.hyperChrome,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  'LANGUAGE PROTOCOL',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamilyHeadline,
                    fontSize: FiftyTypography.body,
                    fontWeight: FiftyTypography.ultrabold,
                    color: colorScheme.onSurface,
                    letterSpacing: 2,
                  ),
                ),
                // Close button
                GestureDetector(
                  onTap: _close,
                  child: Container(
                    padding: const EdgeInsets.all(FiftySpacing.xs),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(FiftyRadii.standard),
                      border: Border.all(
                        color: FiftyColors.hyperChrome.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: FiftyColors.hyperChrome,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: FiftySpacing.sm),
            // Subtitle
            Text(
              'Select communication language',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.mono,
                color: FiftyColors.hyperChrome,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: FiftySpacing.xl),
            // Language chips
            Obx(
              () => Wrap(
                spacing: FiftySpacing.sm,
                runSpacing: FiftySpacing.sm,
                children: LocalizationViewModel.supportedLanguages
                    .map((lang) => _buildLanguageChip(lang, context))
                    .toList(),
              ),
            ),
            const SizedBox(height: FiftySpacing.xl),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FiftyButton(
                  label: 'CANCEL',
                  onPressed: _close,
                  variant: FiftyButtonVariant.secondary,
                  size: FiftyButtonSize.small,
                ),
                const SizedBox(width: FiftySpacing.md),
                FiftyButton(
                  label: 'CONFIRM',
                  onPressed: _confirm,
                  variant: FiftyButtonVariant.primary,
                  size: FiftyButtonSize.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a language selection chip with FDL styling.
  Widget _buildLanguageChip(LanguageModel lang, BuildContext context) {
    final isSelected = controller.language.code == lang.code;
    final flag = _getFlagEmoji(lang.countryCode);

    return FiftyChip(
      label: '$flag ${lang.name}',
      selected: isSelected,
      onTap: () => controller.onChange(lang),
    );
  }

  /// Confirms the language change and saves it using the `LocalizationViewModel`.
  void _confirm() {
    controller.saveLanguageChange();
    RouteManager.back(); // Close the dialog.
  }

  /// Closes the dialog and dismisses any unsaved changes.
  void _close() {
    controller.dismiss();
    RouteManager.back(); // Close the dialog.
  }
}
