import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({
    bool bgmEnabled = true,
    bool bgmPlaying = false,
    bool sfxEnabled = true,
    String? title,
    double? bgmVolume,
    double? sfxVolume,
    ValueChanged<double>? onBgmVolumeChanged,
    ValueChanged<double>? onSfxVolumeChanged,
    bool compact = false,
    bool showCard = true,
  }) {
    return MaterialApp(
      theme: FiftyTheme.dark(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: AudioControlsPanel(
            bgmEnabled: bgmEnabled,
            bgmPlaying: bgmPlaying,
            sfxEnabled: sfxEnabled,
            onPlayBgm: () {},
            onStopBgm: () {},
            onToggleBgm: () {},
            onToggleSfx: () {},
            onTestSfx: () {},
            title: title,
            bgmVolume: bgmVolume,
            sfxVolume: sfxVolume,
            onBgmVolumeChanged: onBgmVolumeChanged,
            onSfxVolumeChanged: onSfxVolumeChanged,
            compact: compact,
            showCard: showCard,
          ),
        ),
      ),
    );
  }

  group('AudioControlsPanel', () {
    testWidgets('renders BGM and SFX labels', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('BGM'), findsOneWidget);
      expect(find.text('SFX'), findsOneWidget);
    });

    testWidgets('shows PLAYING status when BGM is playing', (tester) async {
      await tester.pumpWidget(buildTestWidget(bgmPlaying: true));

      expect(find.text('[PLAYING]'), findsOneWidget);
    });

    testWidgets('shows STOPPED status when BGM is not playing', (tester) async {
      await tester.pumpWidget(buildTestWidget(bgmPlaying: false));

      expect(find.text('[STOPPED]'), findsOneWidget);
    });

    testWidgets('shows ENABLED status when SFX is enabled', (tester) async {
      await tester.pumpWidget(buildTestWidget(sfxEnabled: true));

      expect(find.text('[ENABLED]'), findsOneWidget);
    });

    testWidgets('shows DISABLED status when SFX is disabled', (tester) async {
      await tester.pumpWidget(buildTestWidget(sfxEnabled: false));

      expect(find.text('[DISABLED]'), findsOneWidget);
    });

    testWidgets('shows PLAY button when BGM is stopped', (tester) async {
      await tester.pumpWidget(buildTestWidget(bgmPlaying: false));

      expect(find.text('PLAY'), findsOneWidget);
    });

    testWidgets('shows STOP button when BGM is playing', (tester) async {
      await tester.pumpWidget(buildTestWidget(bgmPlaying: true));

      expect(find.text('STOP'), findsOneWidget);
    });

    testWidgets('shows TEST button for SFX', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('TEST'), findsOneWidget);
    });

    testWidgets('shows title when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(title: 'Audio Settings'));

      expect(find.text('AUDIO SETTINGS'), findsOneWidget);
    });

    testWidgets('hides title when not provided', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // No title text should be present in uppercase form
      expect(find.text('AUDIO SETTINGS'), findsNothing);
    });

    testWidgets('shows volume sliders when volume and callback provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        bgmVolume: 0.8,
        sfxVolume: 0.6,
        onBgmVolumeChanged: (_) {},
        onSfxVolumeChanged: (_) {},
      ));

      // Should find two Slider widgets (BGM and SFX)
      expect(find.byType(Slider), findsNWidgets(2));
    });

    testWidgets('hides volume sliders when no callback provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        bgmVolume: 0.8,
        sfxVolume: 0.6,
      ));

      expect(find.byType(Slider), findsNothing);
    });

    testWidgets('calls onPlayBgm when PLAY is tapped', (tester) async {
      var called = false;

      await tester.pumpWidget(MaterialApp(
        theme: FiftyTheme.dark(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: AudioControlsPanel(
              bgmEnabled: true,
              bgmPlaying: false,
              sfxEnabled: true,
              onPlayBgm: () => called = true,
              onStopBgm: () {},
              onToggleBgm: () {},
              onToggleSfx: () {},
              onTestSfx: () {},
            ),
          ),
        ),
      ));

      await tester.tap(find.text('PLAY'));
      expect(called, isTrue);
    });

    testWidgets('calls onTestSfx when TEST is tapped', (tester) async {
      var called = false;

      await tester.pumpWidget(MaterialApp(
        theme: FiftyTheme.dark(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: AudioControlsPanel(
              bgmEnabled: true,
              bgmPlaying: false,
              sfxEnabled: true,
              onPlayBgm: () {},
              onStopBgm: () {},
              onToggleBgm: () {},
              onToggleSfx: () {},
              onTestSfx: () => called = true,
            ),
          ),
        ),
      ));

      await tester.tap(find.text('TEST'));
      expect(called, isTrue);
    });

    testWidgets('renders in compact mode', (tester) async {
      await tester.pumpWidget(buildTestWidget(compact: true));

      // Should render without errors
      expect(find.text('BGM'), findsOneWidget);
      expect(find.text('SFX'), findsOneWidget);
    });

    testWidgets('renders without card wrapper when showCard is false',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(showCard: false));

      // Should still render content
      expect(find.text('BGM'), findsOneWidget);
      expect(find.text('SFX'), findsOneWidget);
    });
  });
}
