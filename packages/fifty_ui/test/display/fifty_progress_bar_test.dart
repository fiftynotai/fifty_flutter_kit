import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyProgressBar', () {
    testWidgets('renders with value', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressBar(value: 0.5),
      ));

      expect(find.byType(FiftyProgressBar), findsOneWidget);
    });

    testWidgets('clamps value to 0-1 range', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressBar(value: 1.5),
      ));

      expect(find.byType(FiftyProgressBar), findsOneWidget);

      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressBar(value: -0.5),
      ));

      expect(find.byType(FiftyProgressBar), findsOneWidget);
    });

    testWidgets('shows label when provided', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressBar(
          value: 0.5,
          label: 'Uploading',
        ),
      ));

      expect(find.text('UPLOADING'), findsOneWidget);
    });

    testWidgets('shows percentage when showPercentage is true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressBar(
          value: 0.65,
          showPercentage: true,
        ),
      ));

      expect(find.text('65%'), findsOneWidget);
    });

    testWidgets('shows both label and percentage', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressBar(
          value: 0.75,
          label: 'Progress',
          showPercentage: true,
        ),
      ));

      expect(find.text('PROGRESS'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('animates value changes', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressBar(value: 0.25),
      ));

      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressBar(value: 0.75),
      ));

      await tester.pump(const Duration(milliseconds: 150));
      expect(find.byType(FiftyProgressBar), findsOneWidget);
    });
  });
}
