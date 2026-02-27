/// Scroll Sequence Example - Lifecycle Demo Page
///
/// Demonstrates onEnter, onLeave, onEnterBack, and onLeaveBack
/// lifecycle callbacks with a scrollable event log.
library;

import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/frame_generator.dart';

/// Lifecycle callback demo with event log panel.
///
/// Features:
/// - Pinned mode (`pin: true`) with 60 frames
/// - All 4 lifecycle callbacks wired: onEnter, onLeave, onEnterBack, onLeaveBack
/// - Scrollable event log showing fired events with timestamps
/// - Lead-in (300px) and trail-out (800px) for scroll-past space
class LifecyclePage extends StatefulWidget {
  /// Creates the lifecycle demo page.
  const LifecyclePage({super.key});

  @override
  State<LifecyclePage> createState() => _LifecyclePageState();
}

class _LifecyclePageState extends State<LifecyclePage> {
  /// Number of frames for this demo.
  static const int _frameCount = 60;

  /// Recorded lifecycle events.
  final List<_LifecycleEvent> _events = [];

  /// Scroll controller for the event log panel.
  final _logScrollController = ScrollController();

  @override
  void dispose() {
    _logScrollController.dispose();
    super.dispose();
  }

  void _addEvent(String label, Color color) {
    setState(() {
      _events.add(_LifecycleEvent(
        label: label,
        timestamp: DateTime.now(),
        color: color,
      ));
    });
    // Auto-scroll to bottom of the event log.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'LIFECYCLE',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontWeight: FiftyTypography.bold,
            letterSpacing: FiftyTypography.letterSpacingLabelMedium,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Scrollable content area.
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Lead-in spacing.
                  const SizedBox(height: 300),

                  // Instruction text.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FiftySpacing.xxl,
                      vertical: FiftySpacing.lg,
                    ),
                    child: Text(
                      'SCROLL PAST THE SEQUENCE TO TRIGGER LIFECYCLE EVENTS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.labelMedium,
                        fontWeight: FiftyTypography.semiBold,
                        letterSpacing:
                            FiftyTypography.letterSpacingLabelMedium,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),

                  // Pinned scroll sequence with lifecycle callbacks.
                  ScrollSequence(
                    frameCount: _frameCount,
                    framePath: '',
                    loader: GeneratedFrameLoader(frameCount: _frameCount),
                    scrollExtent: 1500,
                    pin: true,
                    onEnter: () => _addEvent(
                      'ENTER',
                      const Color(0xFF4CAF50),
                    ),
                    onLeave: () => _addEvent(
                      'LEAVE',
                      const Color(0xFFF44336),
                    ),
                    onEnterBack: () => _addEvent(
                      'ENTER BACK',
                      const Color(0xFF2196F3),
                    ),
                    onLeaveBack: () => _addEvent(
                      'LEAVE BACK',
                      const Color(0xFFFF9800),
                    ),
                    builder: (context, frameIndex, progress, child) {
                      return Stack(
                        children: [
                          child,
                          Positioned(
                            top: FiftySpacing.md,
                            right: FiftySpacing.md,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: FiftySpacing.sm,
                                vertical: FiftySpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surface
                                    .withValues(alpha: 0.8),
                                borderRadius: FiftyRadii.smRadius,
                                border: Border.all(
                                  color: FiftyColors.borderDark,
                                ),
                              ),
                              child: Text(
                                '${frameIndex + 1} / $_frameCount',
                                style: TextStyle(
                                  fontFamily: FiftyTypography.fontFamily,
                                  fontSize: FiftyTypography.labelSmall,
                                  fontWeight: FiftyTypography.bold,
                                  letterSpacing:
                                      FiftyTypography.letterSpacingLabel,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Trail-out spacing.
                  const SizedBox(height: 800),
                ],
              ),
            ),
          ),

          // Event log panel.
          _EventLogPanel(
            events: _events,
            scrollController: _logScrollController,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

/// A single lifecycle event record.
class _LifecycleEvent {
  const _LifecycleEvent({
    required this.label,
    required this.timestamp,
    required this.color,
  });

  final String label;
  final DateTime timestamp;
  final Color color;
}

/// Scrollable event log panel at the bottom of the page.
class _EventLogPanel extends StatelessWidget {
  const _EventLogPanel({
    required this.events,
    required this.scrollController,
    required this.colorScheme,
  });

  final List<_LifecycleEvent> events;
  final ScrollController scrollController;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: FiftyColors.borderDark),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel header.
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.lg,
              vertical: FiftySpacing.sm,
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: events.isEmpty
                        ? colorScheme.onSurface.withValues(alpha: 0.3)
                        : const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: FiftySpacing.sm),
                Text(
                  'EVENT LOG',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.labelSmall,
                    fontWeight: FiftyTypography.bold,
                    letterSpacing: FiftyTypography.letterSpacingLabel,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const Spacer(),
                Text(
                  '${events.length} EVENTS',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.labelSmall,
                    fontWeight: FiftyTypography.regular,
                    letterSpacing: FiftyTypography.letterSpacingLabel,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),

          // Event list.
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text(
                      'Scroll to trigger lifecycle events',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        fontWeight: FiftyTypography.regular,
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: FiftySpacing.lg,
                    ),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final time =
                          '${event.timestamp.hour.toString().padLeft(2, '0')}:'
                          '${event.timestamp.minute.toString().padLeft(2, '0')}:'
                          '${event.timestamp.second.toString().padLeft(2, '0')}.'
                          '${event.timestamp.millisecond.toString().padLeft(3, '0')}';

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: FiftySpacing.xs,
                        ),
                        child: Row(
                          children: [
                            // Colored event label.
                            Container(
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                horizontal: FiftySpacing.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: event.color.withValues(alpha: 0.15),
                                borderRadius: FiftyRadii.smRadius,
                              ),
                              child: Text(
                                event.label,
                                style: TextStyle(
                                  fontFamily: FiftyTypography.fontFamily,
                                  fontSize: FiftyTypography.labelSmall,
                                  fontWeight: FiftyTypography.bold,
                                  letterSpacing:
                                      FiftyTypography.letterSpacingLabel,
                                  color: event.color,
                                ),
                              ),
                            ),
                            const SizedBox(width: FiftySpacing.md),
                            // Timestamp.
                            Text(
                              time,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: FiftyTypography.labelSmall,
                                fontWeight: FiftyTypography.regular,
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
