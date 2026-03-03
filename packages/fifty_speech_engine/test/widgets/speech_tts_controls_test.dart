import 'package:fifty_speech_engine/src/widgets/speech_tts_controls.dart';
import 'package:fifty_speech_engine/src/widgets/speech_tts_state.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({
    bool enabled = true,
    ValueChanged<bool>? onEnabledChanged,
    double rate = 1.0,
    ValueChanged<double>? onRateChanged,
    double pitch = 1.0,
    ValueChanged<double>? onPitchChanged,
    double volume = 1.0,
    ValueChanged<double>? onVolumeChanged,
    bool isSpeaking = false,
    bool compact = false,
    bool showCard = true,
    SpeechTtsContentBuilder? contentBuilder,
  }) {
    return MaterialApp(
      theme: FiftyTheme.dark(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: SpeechTtsControls(
            enabled: enabled,
            onEnabledChanged: onEnabledChanged ?? (_) {},
            rate: rate,
            onRateChanged: onRateChanged,
            pitch: pitch,
            onPitchChanged: onPitchChanged,
            volume: volume,
            onVolumeChanged: onVolumeChanged,
            isSpeaking: isSpeaking,
            compact: compact,
            showCard: showCard,
            contentBuilder: contentBuilder,
          ),
        ),
      ),
    );
  }

  group('SpeechTtsControls', () {
    group('default rendering', () {
      testWidgets('renders TEXT-TO-SPEECH header text', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('TEXT-TO-SPEECH'), findsOneWidget);
      });

      testWidgets('shows sliders when enabled with callbacks', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          enabled: true,
          onRateChanged: (_) {},
          onPitchChanged: (_) {},
          onVolumeChanged: (_) {},
        ));

        expect(find.text('RATE'), findsOneWidget);
        expect(find.text('PITCH'), findsOneWidget);
        expect(find.text('VOLUME'), findsOneWidget);
      });

      testWidgets('hides sliders when disabled', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          enabled: false,
          onRateChanged: (_) {},
        ));

        expect(find.text('RATE'), findsNothing);
      });
    });

    group('contentBuilder', () {
      testWidgets('when contentBuilder provided, renders builder widget',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          contentBuilder: (state) => const Text('Custom TTS Content'),
        ));

        expect(find.text('Custom TTS Content'), findsOneWidget);
        // Default header should NOT appear
        expect(find.text('TEXT-TO-SPEECH'), findsNothing);
      });

      testWidgets('when contentBuilder null, renders default content',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          contentBuilder: null,
        ));

        expect(find.text('TEXT-TO-SPEECH'), findsOneWidget);
      });

      testWidgets('builder receives correct SpeechTtsState values',
          (tester) async {
        SpeechTtsState? capturedState;

        await tester.pumpWidget(buildTestWidget(
          enabled: true,
          rate: 1.5,
          pitch: 0.8,
          volume: 0.6,
          isSpeaking: true,
          compact: true,
          onRateChanged: (_) {},
          onPitchChanged: (_) {},
          onVolumeChanged: (_) {},
          contentBuilder: (state) {
            capturedState = state;
            return const Text('Custom TTS');
          },
        ));

        expect(capturedState, isNotNull);
        expect(capturedState!.enabled, isTrue);
        expect(capturedState!.rate, 1.5);
        expect(capturedState!.pitch, 0.8);
        expect(capturedState!.volume, 0.6);
        expect(capturedState!.isSpeaking, isTrue);
        expect(capturedState!.compact, isTrue);
        expect(capturedState!.onRateChanged, isNotNull);
        expect(capturedState!.onPitchChanged, isNotNull);
        expect(capturedState!.onVolumeChanged, isNotNull);
        expect(capturedState!.onEnabledChanged, isNotNull);
      });

      testWidgets('builder receives null callbacks when not provided',
          (tester) async {
        SpeechTtsState? capturedState;

        await tester.pumpWidget(buildTestWidget(
          contentBuilder: (state) {
            capturedState = state;
            return const Text('Custom TTS');
          },
        ));

        expect(capturedState, isNotNull);
        expect(capturedState!.onRateChanged, isNull);
        expect(capturedState!.onPitchChanged, isNull);
        expect(capturedState!.onVolumeChanged, isNull);
      });

      testWidgets('showCard=true wraps builder output in FiftyCard',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          showCard: true,
          contentBuilder: (state) => const Text('Custom TTS'),
        ));

        expect(find.byType(FiftyCard), findsOneWidget);
        expect(find.text('Custom TTS'), findsOneWidget);
      });

      testWidgets('showCard=false returns builder output directly',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          showCard: false,
          contentBuilder: (state) => const Text('Custom TTS'),
        ));

        expect(find.byType(FiftyCard), findsNothing);
        expect(find.text('Custom TTS'), findsOneWidget);
      });
    });
  });
}
