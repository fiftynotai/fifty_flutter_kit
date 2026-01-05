/// Map Demo Page
///
/// Demonstrates map engine with audio integration.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_indicator.dart';
import '../actions/map_demo_actions.dart';
import '../viewmodel/map_demo_viewmodel.dart';
import 'widgets/audio_controls.dart';
import 'widgets/map_controls.dart';

/// Map demo page widget.
///
/// Shows map rendering with audio playback controls.
class MapDemoPage extends StatefulWidget {
  const MapDemoPage({super.key});

  @override
  State<MapDemoPage> createState() => _MapDemoPageState();
}

class _MapDemoPageState extends State<MapDemoPage> {
  late MapDemoActions _actions;

  @override
  void initState() {
    super.initState();
    _actions = serviceLocator<MapDemoActions>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _actions.onInitialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapDemoViewModel>(
      builder: (context, viewModel, _) {
        return DemoScaffold(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Row
                Row(
                  children: [
                    StatusIndicator(
                      label: 'AUDIO',
                      state: viewModel.isInitialized
                          ? (viewModel.bgmPlaying
                              ? StatusState.ready
                              : StatusState.idle)
                          : StatusState.loading,
                    ),
                    const SizedBox(width: FiftySpacing.lg),
                    const StatusIndicator(
                      label: 'MAP',
                      state: StatusState.ready,
                    ),
                  ],
                ),
                const SizedBox(height: FiftySpacing.xl),

                // Audio Controls Section
                const SectionHeader(
                  title: 'Audio Controls',
                  subtitle: 'BGM and SFX integration',
                ),
                AudioControlsWidget(
                  bgmEnabled: viewModel.bgmEnabled,
                  sfxEnabled: viewModel.sfxEnabled,
                  bgmPlaying: viewModel.bgmPlaying,
                  onPlayBgm: _actions.onPlayBgmTapped,
                  onStopBgm: _actions.onStopBgmTapped,
                  onToggleBgm: _actions.onToggleBgm,
                  onToggleSfx: _actions.onToggleSfx,
                  onTestSfx: _actions.onTestSfxTapped,
                ),
                const SizedBox(height: FiftySpacing.xl),

                // Map Controls Section
                const SectionHeader(
                  title: 'Camera Controls',
                  subtitle: 'Map navigation',
                ),
                MapControlsWidget(
                  onZoomIn: _actions.onZoomInTapped,
                  onZoomOut: _actions.onZoomOutTapped,
                  onCenter: _actions.onCenterTapped,
                ),
                const SizedBox(height: FiftySpacing.xl),

                // Map Preview Section
                const SectionHeader(
                  title: 'Map Preview',
                  subtitle: 'Interactive grid map',
                ),
                const FiftyCard(
                  padding: EdgeInsets.all(FiftySpacing.lg),
                  child: SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 64,
                            color: FiftyColors.hyperChrome,
                          ),
                          SizedBox(height: FiftySpacing.md),
                          Text(
                            'MAP WIDGET PLACEHOLDER',
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamilyMono,
                              fontSize: FiftyTypography.body,
                              color: FiftyColors.hyperChrome,
                            ),
                          ),
                          SizedBox(height: FiftySpacing.sm),
                          Text(
                            'FiftyMapWidget renders here with entity interactions',
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamilyMono,
                              fontSize: FiftyTypography.mono,
                              color: FiftyColors.hyperChrome,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
