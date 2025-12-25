import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyDataSlate', () {
    testWidgets('renders with data', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyDataSlate(
          data: {
            'CPU': '45%',
            'Memory': '8.2 GB',
          },
        ),
      ));

      expect(find.text('CPU:'), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);
      expect(find.text('Memory:'), findsOneWidget);
      expect(find.text('8.2 GB'), findsOneWidget);
    });

    testWidgets('renders with title', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyDataSlate(
          title: 'System Status',
          data: {'Status': 'Online'},
        ),
      ));

      expect(find.text('SYSTEM STATUS'), findsOneWidget);
      expect(find.text('> '), findsOneWidget);
    });

    testWidgets('renders without border when showBorder is false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyDataSlate(
          data: {'Key': 'Value'},
          showBorder: false,
        ),
      ));

      expect(find.byType(FiftyDataSlate), findsOneWidget);
    });

    testWidgets('shows glow when showGlow is true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyDataSlate(
          data: {'Key': 'Value'},
          showGlow: true,
        ),
      ));

      expect(find.byType(FiftyDataSlate), findsOneWidget);
    });

    testWidgets('handles empty data', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyDataSlate(
          data: {},
        ),
      ));

      expect(find.byType(FiftyDataSlate), findsOneWidget);
    });
  });
}
