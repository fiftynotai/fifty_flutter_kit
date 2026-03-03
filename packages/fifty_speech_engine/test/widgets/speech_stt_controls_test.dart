import 'package:fifty_speech_engine/src/widgets/speech_stt_controls.dart';
import 'package:fifty_speech_engine/src/widgets/speech_stt_state.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({
    bool enabled = true,
    ValueChanged<bool>? onEnabledChanged,
    bool isListening = false,
    VoidCallback? onListenPressed,
    String recognizedText = '',
    bool isAvailable = true,
    String? errorMessage,
    VoidCallback? onClear,
    bool compact = false,
    bool showCard = true,
    String? hintText,
    SpeechSttContentBuilder? contentBuilder,
  }) {
    return MaterialApp(
      theme: FiftyTheme.dark(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: SpeechSttControls(
            enabled: enabled,
            onEnabledChanged: onEnabledChanged ?? (_) {},
            isListening: isListening,
            onListenPressed: onListenPressed ?? () {},
            recognizedText: recognizedText,
            isAvailable: isAvailable,
            errorMessage: errorMessage,
            onClear: onClear,
            compact: compact,
            showCard: showCard,
            hintText: hintText,
            contentBuilder: contentBuilder,
          ),
        ),
      ),
    );
  }

  group('SpeechSttControls', () {
    group('default rendering', () {
      testWidgets('renders SPEECH-TO-TEXT header text', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('SPEECH-TO-TEXT'), findsOneWidget);
      });

      testWidgets('shows mic section when enabled', (tester) async {
        // isListening=false so no pulsing animation -- pumpAndSettle is safe
        await tester.pumpWidget(buildTestWidget(enabled: true));
        await tester.pumpAndSettle();

        expect(find.text('TAP TO SPEAK'), findsOneWidget);
      });

      testWidgets('hides mic section when disabled', (tester) async {
        await tester.pumpWidget(buildTestWidget(enabled: false));
        await tester.pumpAndSettle();

        expect(find.text('TAP TO SPEAK'), findsNothing);
      });
    });

    group('contentBuilder', () {
      testWidgets('when contentBuilder provided, renders builder widget',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          contentBuilder: (state) => const Text('Custom STT Content'),
        ));

        expect(find.text('Custom STT Content'), findsOneWidget);
        // Default header should NOT appear
        expect(find.text('SPEECH-TO-TEXT'), findsNothing);
      });

      testWidgets('when contentBuilder null, renders default content',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          contentBuilder: null,
        ));

        expect(find.text('SPEECH-TO-TEXT'), findsOneWidget);
      });

      testWidgets('builder receives correct SpeechSttState values',
          (tester) async {
        SpeechSttState? capturedState;

        await tester.pumpWidget(buildTestWidget(
          enabled: true,
          isListening: false,
          recognizedText: 'hello world',
          isAvailable: true,
          errorMessage: 'test error',
          compact: true,
          hintText: 'Speak now',
          contentBuilder: (state) {
            capturedState = state;
            return const Text('Custom STT');
          },
        ));

        expect(capturedState, isNotNull);
        expect(capturedState!.enabled, isTrue);
        expect(capturedState!.isListening, isFalse);
        expect(capturedState!.recognizedText, 'hello world');
        expect(capturedState!.isAvailable, isTrue);
        expect(capturedState!.errorMessage, 'test error');
        expect(capturedState!.compact, isTrue);
        expect(capturedState!.hintText, 'Speak now');
        expect(capturedState!.onEnabledChanged, isNotNull);
        expect(capturedState!.onListenPressed, isNotNull);
      });

      testWidgets('builder receives null optional fields when not provided',
          (tester) async {
        SpeechSttState? capturedState;

        await tester.pumpWidget(buildTestWidget(
          errorMessage: null,
          onClear: null,
          hintText: null,
          contentBuilder: (state) {
            capturedState = state;
            return const Text('Custom STT');
          },
        ));

        expect(capturedState, isNotNull);
        expect(capturedState!.errorMessage, isNull);
        expect(capturedState!.onClear, isNull);
        expect(capturedState!.hintText, isNull);
      });

      testWidgets('showCard=true wraps builder output in FiftyCard',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          showCard: true,
          contentBuilder: (state) => const Text('Custom STT'),
        ));

        expect(find.byType(FiftyCard), findsOneWidget);
        expect(find.text('Custom STT'), findsOneWidget);
      });

      testWidgets('showCard=false returns builder output directly',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          showCard: false,
          contentBuilder: (state) => const Text('Custom STT'),
        ));

        expect(find.byType(FiftyCard), findsNothing);
        expect(find.text('Custom STT'), findsOneWidget);
      });
    });
  });
}
