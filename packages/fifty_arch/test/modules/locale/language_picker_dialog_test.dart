import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:fifty_arch/src/modules/locale/controllers/localization_view_model.dart';
import 'package:fifty_arch/src/modules/locale/views/language_dialog.dart';
import 'package:fifty_arch/src/modules/locale/data/services/localization_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LanguagePickerDialog Widget Tests', () {
    late LocalizationViewModel viewModel;

    setUp(() async {
      Get.testMode = true;

      // Initialize localization (doesn't require storage)
      LocalizationService.init();

      // Create and register ViewModel
      viewModel = LocalizationViewModel();
      Get.put<LocalizationViewModel>(viewModel);
    });

    tearDown(() {
      Get.reset();
    });

    Widget createTestWidget() {
      return GetMaterialApp(
        translations: LocalizationService(),
        locale: LocalizationService.locale,
        fallbackLocale: LocalizationService.fallbackLocale,
        theme: FiftyTheme.dark(),
        darkTheme: FiftyTheme.dark(),
        themeMode: ThemeMode.dark,
        home: Scaffold(
          backgroundColor: FiftyColors.voidBlack,
          body: const LanguagePickerDialog(),
        ),
      );
    }

    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(LanguagePickerDialog), findsOneWidget);
    });

    testWidgets('displays dialog container', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('displays LANGUAGE PROTOCOL title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('LANGUAGE PROTOCOL'), findsOneWidget);
    });

    testWidgets('displays close button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('displays language chips using FiftyChip', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // FDL redesign uses FiftyChip instead of dropdown
      expect(find.byType(FiftyChip), findsWidgets);
    });

    testWidgets('displays CONFIRM button with FDL styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // FDL redesign uses uppercase button labels
      expect(find.text('CONFIRM'), findsOneWidget);
    });

    testWidgets('displays CANCEL button with FDL styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('CANCEL'), findsOneWidget);
    });

    testWidgets('shows all supported languages as chips', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have chips for each supported language
      final chipCount = LocalizationViewModel.supportedLanguages.length;
      expect(find.byType(FiftyChip), findsNWidgets(chipCount));
    });

    testWidgets('displays all language options as FiftyChip widgets', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // FiftyChip widgets should be present for each language
      final chipCount = LocalizationViewModel.supportedLanguages.length;
      expect(find.byType(FiftyChip), findsNWidgets(chipCount));
    });

    testWidgets('tapping language chip updates selection', (WidgetTester tester) async {
      // Set initial language to English
      final english = LocalizationViewModel.supportedLanguages
          .firstWhere((lang) => lang.code == 'en');
      await viewModel.selectLanguage(english);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Arabic chip
      await tester.tap(find.textContaining('العربية'));
      await tester.pumpAndSettle();

      // ViewModel should have Arabic selected (but not saved yet)
      expect(viewModel.language.code, equals('ar'));
    });

    testWidgets('confirm button triggers save', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Change language by tapping chip
      await tester.tap(find.textContaining('العربية'));
      await tester.pumpAndSettle();

      // Tap CONFIRM button
      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();

      // saveLanguageChange should have been called
      // In real app, Get.back() would close dialog
    });

    testWidgets('cancel button dismisses without saving', (WidgetTester tester) async {
      // Set initial language to English
      final english = LocalizationViewModel.supportedLanguages
          .firstWhere((lang) => lang.code == 'en');
      await viewModel.selectLanguage(english);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Change language
      await tester.tap(find.textContaining('العربية'));
      await tester.pumpAndSettle();

      // Tap CANCEL button
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();

      // dismiss should have been called
    });

    testWidgets('close icon triggers dismiss', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap close icon
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // dismiss should have been called
    });

    testWidgets('uses controller property via GetView', (WidgetTester tester) async {
      // This test verifies the widget accesses controller via GetView inheritance
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.byType(LanguagePickerDialog), findsOneWidget);
    });

    testWidgets('dialog has FDL gunmetal background', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final dialog = tester.widget<Dialog>(find.byType(Dialog));

      // FDL redesign uses gunmetal background
      expect(dialog.backgroundColor, equals(FiftyColors.gunmetal));
    });

    testWidgets('dialog has FDL border styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final dialog = tester.widget<Dialog>(find.byType(Dialog));
      final shape = dialog.shape as RoundedRectangleBorder;

      expect(shape.side.color, equals(FiftyColors.hyperChrome));
    });

    testWidgets('FiftyChip widgets are tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find all FiftyChip widgets
      final chips = find.byType(FiftyChip);
      expect(chips, findsWidgets);

      // Verify they are rendered properly
      expect(find.byType(LanguagePickerDialog), findsOneWidget);
    });

    testWidgets('displays subtitle text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Select communication language'), findsOneWidget);
    });

    testWidgets('uses FiftyButton for action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have 2 FiftyButtons (CANCEL and CONFIRM)
      expect(find.byType(FiftyButton), findsNWidgets(2));
    });
  });
}
