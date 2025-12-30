import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

// TODO: Uncomment when SpaceViewModel is implemented
// import 'package:get/get.dart';
// import '/src/presentation/widgets/api_handler.dart';
import 'widgets/apod_card.dart';
import 'widgets/neo_list_tile.dart';
import 'widgets/status_panel.dart';

/// **OrbitalCommandPage**
///
/// The main dashboard page for the Space module displaying NASA API data.
///
/// **Purpose**:
/// This page serves as the central hub for space data visualization,
/// demonstrating the template's API integration patterns with NASA's APIs.
///
/// **Features**:
/// - APOD (Astronomy Picture of the Day) section at top
/// - NEO threat summary with FiftyDataSlate cards
/// - Recent NEO list with hazard indicators
/// - Pull-to-refresh support
/// - ApiHandler for loading/error states
///
/// **Pattern Flow**:
/// ```
/// SpaceService.fetchApod() / fetchNeos()
///     -> (extends ApiService)
/// apiFetch() wrapper
///     -> (emits Stream<ApiResponse<T>>)
/// SpaceViewModel.apod / neos (Rx<ApiResponse<Model>>)
///     -> (observed by GetX)
/// ApiHandler<Model>
///     -> (renders based on state)
/// OrbitalCommandPage widgets
/// ```
///
/// **Usage**:
/// ```dart
/// GetPage(
///   name: '/orbital-command',
///   page: () => const OrbitalCommandPage(),
///   binding: SpaceBindings(),
/// )
/// ```
class OrbitalCommandPage extends StatelessWidget {
  const OrbitalCommandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FiftyColors.voidBlack,
      appBar: AppBar(
        backgroundColor: FiftyColors.voidBlack,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.radar,
              color: FiftyColors.crimsonPulse,
              size: 24,
            ),
            const SizedBox(width: FiftySpacing.md),
            Text(
              'ORBITAL COMMAND',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamilyHeadline,
                fontSize: FiftyTypography.body + 2,
                fontWeight: FiftyTypography.ultrabold,
                color: FiftyColors.terminalWhite,
                letterSpacing: FiftyTypography.tight * (FiftyTypography.body + 2),
              ),
            ),
          ],
        ),
        actions: [
          // Status indicator
          Padding(
            padding: const EdgeInsets.only(right: FiftySpacing.md),
            child: StatusIndicator(
              status: ApiConnectionStatus.connected,
              label: 'NASA',
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: FiftyColors.crimsonPulse,
        backgroundColor: FiftyColors.gunmetal,
        onRefresh: () async {
          // TODO: Wire to SpaceViewModel.refreshData()
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(FiftySpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: APOD
              _buildSectionHeader('ASTRONOMY PICTURE OF THE DAY'),
              const SizedBox(height: FiftySpacing.md),

              // APOD Card (placeholder for ApiHandler integration)
              ApodCard(
                title: 'The Horsehead Nebula in Infrared',
                imageUrl: 'https://apod.nasa.gov/apod/image/2401/Horsehead_HubbleEbisawa_960.jpg',
                date: DateTime(2025, 1, 15),
                hdUrl: 'https://apod.nasa.gov/apod/image/2401/Horsehead_HubbleEbisawa_1600.jpg',
                onViewHd: () {
                  // TODO: Launch URL
                },
                onTap: () {
                  // TODO: Show detail modal
                },
              ),

              const SizedBox(height: FiftySpacing.xl),

              // Section: Status Panel
              _buildSectionHeader('SYSTEM STATUS'),
              const SizedBox(height: FiftySpacing.md),

              StatusPanel(
                connectionStatus: ApiConnectionStatus.connected,
                lastSyncTime: DateTime.now().subtract(const Duration(minutes: 5)),
                objectsTracked: 14,
              ),

              const SizedBox(height: FiftySpacing.xl),

              // Section: NEO Threat Summary
              _buildSectionHeader('THREAT SUMMARY'),
              const SizedBox(height: FiftySpacing.md),

              _buildThreatSummaryCards(),

              const SizedBox(height: FiftySpacing.xl),

              // Section: Recent NEOs
              _buildSectionHeader('RECENT NEAR-EARTH OBJECTS'),
              const SizedBox(height: FiftySpacing.md),

              // NEO List (placeholder data)
              _buildNeoList(),

              // Bottom spacing for safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom + FiftySpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a section header with Monument Extended styling.
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: FiftyColors.crimsonPulse,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: FiftySpacing.sm),
        Text(
          title,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamilyMono,
            fontSize: FiftyTypography.mono,
            fontWeight: FiftyTypography.medium,
            color: FiftyColors.hyperChrome,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  /// Builds the threat summary cards using FiftyDataSlate.
  Widget _buildThreatSummaryCards() {
    return Row(
      children: [
        // Total Objects
        Expanded(
          child: FiftyDataSlate(
            title: 'TOTAL',
            data: {
              'Objects': '14',
              'Today': '6',
            },
          ),
        ),
        const SizedBox(width: FiftySpacing.md),

        // Hazardous Count
        Expanded(
          child: FiftyDataSlate(
            title: 'HAZARDOUS',
            showGlow: true,
            data: {
              'Count': '3',
              'Closest': '1.2M km',
            },
          ),
        ),
        const SizedBox(width: FiftySpacing.md),

        // Closest Approach
        Expanded(
          child: FiftyDataSlate(
            title: 'CLOSEST',
            data: {
              'Distance': '384k km',
              'ETA': '6h 42m',
            },
          ),
        ),
      ],
    );
  }

  /// Builds the list of recent NEOs.
  Widget _buildNeoList() {
    // Placeholder data - will be replaced with ApiHandler
    final neos = [
      (
        name: '(2024 AB1)',
        diameterMin: 45.0,
        diameterMax: 102.0,
        velocity: 12.5,
        missDistance: 1200000.0,
        isHazardous: true,
        date: DateTime(2025, 1, 20),
      ),
      (
        name: '(2024 CD3)',
        diameterMin: 28.0,
        diameterMax: 62.0,
        velocity: 8.3,
        missDistance: 3500000.0,
        isHazardous: false,
        date: DateTime(2025, 1, 21),
      ),
      (
        name: '(2025 EF4)',
        diameterMin: 120.0,
        diameterMax: 268.0,
        velocity: 18.7,
        missDistance: 890000.0,
        isHazardous: true,
        date: DateTime(2025, 1, 22),
      ),
      (
        name: '(2024 GH5)',
        diameterMin: 15.0,
        diameterMax: 34.0,
        velocity: 6.1,
        missDistance: 5200000.0,
        isHazardous: false,
        date: DateTime(2025, 1, 23),
      ),
    ];

    return Column(
      children: neos
          .map(
            (neo) => Padding(
              padding: const EdgeInsets.only(bottom: FiftySpacing.md),
              child: NeoListTile(
                name: neo.name,
                diameterMin: neo.diameterMin,
                diameterMax: neo.diameterMax,
                velocityKmPerSecond: neo.velocity,
                missDistanceKm: neo.missDistance,
                isHazardous: neo.isHazardous,
                closeApproachDate: neo.date,
                onTap: () {
                  // TODO: Show NEO detail
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
