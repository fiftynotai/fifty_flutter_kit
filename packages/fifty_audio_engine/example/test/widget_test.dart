// Basic smoke test for Fifty Audio Engine Example
//
// This test verifies the app launches and renders the main UI components.

import 'package:flutter_test/flutter_test.dart';

import 'package:fifty_audio_engine_example/main.dart';

void main() {
  testWidgets('App launches and shows audio engine UI', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AudioEngineExampleApp());

    // Wait for animations to settle
    await tester.pumpAndSettle();

    // Verify the app title is displayed
    expect(find.text('AUDIO ENGINE'), findsOneWidget);

    // Verify navigation tabs are present
    expect(find.text('BGM'), findsOneWidget);
    expect(find.text('SFX'), findsOneWidget);
  });
}
