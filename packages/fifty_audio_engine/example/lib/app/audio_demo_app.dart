import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../features/bgm/bgm_view.dart';
import '../features/global/global_view.dart';
import '../features/sfx/sfx_view.dart';
import '../features/voice/voice_view.dart';

/// Example launcher with Card-based navigation.
///
/// Provides a list of example tiles that navigate to individual
/// feature pages: BGM, SFX, Voice, and Global controls.
class ExampleLauncher extends StatelessWidget {
  const ExampleLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Engine Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(FiftySpacing.md),
        children: [
          _buildExampleTile(
            context,
            title: 'BGM Player',
            subtitle: 'Background music playback controls',
            icon: Icons.music_note,
            builder: (context) => const BgmView(),
          ),
          const SizedBox(height: FiftySpacing.md),
          _buildExampleTile(
            context,
            title: 'SFX Player',
            subtitle: 'Sound effects grid and controls',
            icon: Icons.speaker,
            builder: (context) => const SfxView(),
          ),
          const SizedBox(height: FiftySpacing.md),
          _buildExampleTile(
            context,
            title: 'Voice Player',
            subtitle: 'Voice lines with BGM ducking',
            icon: Icons.record_voice_over,
            builder: (context) => const VoiceView(),
          ),
          const SizedBox(height: FiftySpacing.md),
          _buildExampleTile(
            context,
            title: 'Global Controls',
            subtitle: 'Master volume, fade, and channel status',
            icon: Icons.settings,
            builder: (context) => const GlobalView(),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required WidgetBuilder builder,
  }) {
    return Card(
      color: FiftyColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.lgRadius,
        side: BorderSide(color: FiftyColors.borderDark),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(FiftySpacing.md),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: FiftyColors.burgundy.withValues(alpha: 0.2),
            borderRadius: FiftyRadii.mdRadius,
          ),
          child: Icon(icon, color: FiftyColors.burgundy),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontWeight: FiftyTypography.bold,
            color: FiftyColors.cream,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            color: FiftyColors.cream.withValues(alpha: 0.7),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: FiftyColors.cream.withValues(alpha: 0.5),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: builder),
        ),
      ),
    );
  }
}
