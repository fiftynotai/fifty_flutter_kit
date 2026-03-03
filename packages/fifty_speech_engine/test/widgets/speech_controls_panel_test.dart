import 'package:fifty_speech_engine/src/widgets/speech_controls_panel.dart';
import 'package:fifty_speech_engine/src/widgets/speech_stt_controls.dart';
import 'package:fifty_speech_engine/src/widgets/speech_stt_state.dart';
import 'package:fifty_speech_engine/src/widgets/speech_tts_controls.dart';
import 'package:fifty_speech_engine/src/widgets/speech_tts_state.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({
    // TTS
    bool ttsEnabled = true,
    ValueChanged<bool>? onTtsEnabledChanged,
    double rate = 1.0,
    ValueChanged<double>? onRateChanged,
    double pitch = 1.0,
    ValueChanged<double>? onPitchChanged,
    double volume = 1.0,
    ValueChanged<double>? onVolumeChanged,
    bool isSpeaking = false,
    // STT -- isListening=false by default to avoid PulsingDot animation
    bool sttEnabled = true,
    ValueChanged<bool>? onSttEnabledChanged,
    bool isListening = false,
    VoidCallback? onListenPressed,
    String recognizedText = '',
    bool isSttAvailable = true,
    String? sttErrorMessage,
    VoidCallback? onClearRecognizedText,
    String? sttHintText,
    // Panel
    bool showTts = true,
    bool showStt = true,
    bool compact = false,
    String? title,
    SpeechTtsContentBuilder? ttsBuilder,
    SpeechSttContentBuilder? sttBuilder,
  }) {
    return MaterialApp(
      theme: FiftyTheme.dark(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: SpeechControlsPanel(
            ttsEnabled: ttsEnabled,
            onTtsEnabledChanged: onTtsEnabledChanged ?? (_) {},
            rate: rate,
            onRateChanged: onRateChanged,
            pitch: pitch,
            onPitchChanged: onPitchChanged,
            volume: volume,
            onVolumeChanged: onVolumeChanged,
            isSpeaking: isSpeaking,
            sttEnabled: sttEnabled,
            onSttEnabledChanged: onSttEnabledChanged ?? (_) {},
            isListening: isListening,
            onListenPressed: onListenPressed ?? () {},
            recognizedText: recognizedText,
            isSttAvailable: isSttAvailable,
            sttErrorMessage: sttErrorMessage,
            onClearRecognizedText: onClearRecognizedText,
            sttHintText: sttHintText,
            showTts: showTts,
            showStt: showStt,
            compact: compact,
            title: title,
            ttsBuilder: ttsBuilder,
            sttBuilder: sttBuilder,
          ),
        ),
      ),
    );
  }

  group('SpeechControlsPanel', () {
    group('ttsBuilder', () {
      testWidgets('ttsBuilder replaces TTS section content', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          ttsBuilder: (state) => const Text('Custom TTS Panel'),
        ));

        expect(find.text('Custom TTS Panel'), findsOneWidget);
        // Default TTS header should NOT appear
        expect(find.text('TEXT-TO-SPEECH'), findsNothing);
      });

      testWidgets('null ttsBuilder renders default TTS controls',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          ttsBuilder: null,
        ));
        await tester.pumpAndSettle();

        expect(find.text('TEXT-TO-SPEECH'), findsOneWidget);
      });

      testWidgets('ttsBuilder receives correct state values', (tester) async {
        SpeechTtsState? capturedState;

        await tester.pumpWidget(buildTestWidget(
          ttsEnabled: true,
          rate: 1.8,
          pitch: 0.7,
          volume: 0.4,
          isSpeaking: true,
          compact: true,
          onRateChanged: (_) {},
          ttsBuilder: (state) {
            capturedState = state;
            return const Text('Custom TTS');
          },
        ));

        expect(capturedState, isNotNull);
        expect(capturedState!.enabled, isTrue);
        expect(capturedState!.rate, 1.8);
        expect(capturedState!.pitch, 0.7);
        expect(capturedState!.volume, 0.4);
        expect(capturedState!.isSpeaking, isTrue);
        expect(capturedState!.compact, isTrue);
        expect(capturedState!.onRateChanged, isNotNull);
      });
    });

    group('sttBuilder', () {
      testWidgets('sttBuilder replaces STT section content', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          sttBuilder: (state) => const Text('Custom STT Panel'),
        ));

        expect(find.text('Custom STT Panel'), findsOneWidget);
        // Default STT header should NOT appear
        expect(find.text('SPEECH-TO-TEXT'), findsNothing);
      });

      testWidgets('null sttBuilder renders default STT controls',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          sttBuilder: null,
        ));
        await tester.pumpAndSettle();

        expect(find.text('SPEECH-TO-TEXT'), findsOneWidget);
      });

      testWidgets('sttBuilder receives correct state values', (tester) async {
        SpeechSttState? capturedState;

        await tester.pumpWidget(buildTestWidget(
          sttEnabled: true,
          isListening: false,
          recognizedText: 'test text',
          isSttAvailable: true,
          sttErrorMessage: 'err',
          sttHintText: 'Tap',
          compact: true,
          sttBuilder: (state) {
            capturedState = state;
            return const Text('Custom STT');
          },
        ));

        expect(capturedState, isNotNull);
        expect(capturedState!.enabled, isTrue);
        expect(capturedState!.isListening, isFalse);
        expect(capturedState!.recognizedText, 'test text');
        expect(capturedState!.isAvailable, isTrue);
        expect(capturedState!.errorMessage, 'err');
        expect(capturedState!.hintText, 'Tap');
        expect(capturedState!.compact, isTrue);
      });
    });

    group('both builders', () {
      testWidgets('both builders work simultaneously', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          ttsBuilder: (state) => const Text('TTS Custom'),
          sttBuilder: (state) => const Text('STT Custom'),
        ));

        expect(find.text('TTS Custom'), findsOneWidget);
        expect(find.text('STT Custom'), findsOneWidget);
        // Neither default header should appear
        expect(find.text('TEXT-TO-SPEECH'), findsNothing);
        expect(find.text('SPEECH-TO-TEXT'), findsNothing);
      });

      testWidgets('panel card structure preserved with builders',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          ttsBuilder: (state) => const Text('TTS Custom'),
          sttBuilder: (state) => const Text('STT Custom'),
        ));

        // The outer FiftyCard from the panel should still be present
        expect(find.byType(FiftyCard), findsOneWidget);
      });
    });
  });
}
