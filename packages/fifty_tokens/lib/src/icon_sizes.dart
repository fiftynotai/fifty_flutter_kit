import 'config/fifty_tokens_config.dart';

/// Fifty.dev icon size tokens -- reads from the active [FiftyPreset].
///
/// Standardized icon sizes for consistent visual hierarchy.
class FiftyIconSizes {
  FiftyIconSizes._();

  /// Small icon (16px) - Badges, indicators, inline icons.
  static double get sm => FiftyTokens.active.iconSizes.sm;

  /// Medium icon (20px) - Buttons, list tiles, form fields.
  static double get md => FiftyTokens.active.iconSizes.md;

  /// Large icon (24px) - Navigation bar, standard actions.
  static double get lg => FiftyTokens.active.iconSizes.lg;

  /// Extra-large icon (36px) - Branding, feature highlights.
  static double get xl => FiftyTokens.active.iconSizes.xl;

  /// 2X large icon (44px) - Hero icons, empty states.
  static double get xxl => FiftyTokens.active.iconSizes.xxl;

  /// Hero icon (48px) - Hero action buttons, splash screens.
  static double get hero => FiftyTokens.active.iconSizes.hero;
}
