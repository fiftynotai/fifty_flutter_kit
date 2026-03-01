import 'package:fifty_connectivity/fifty_connectivity.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/status_card.dart';

/// Live connection status dashboard showcasing [ConnectionViewModel] state.
class HomeScreen extends StatelessWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<ConnectionViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Connection Status')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(FiftySpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Live status card
            Obx(() => StatusCard(type: vm.connectionType.value)),
            SizedBox(height: FiftySpacing.xl),

            // Connection telemetry
            Obx(
              () => FiftyDataSlate(
                title: 'CONNECTION TELEMETRY',
                data: {
                  'Type': vm.connectionType.value.name.toUpperCase(),
                  'Connected': vm.isConnected() ? 'YES' : 'NO',
                  'Offline Timer': vm.dialogTimer.value,
                },
              ),
            ),
            SizedBox(height: FiftySpacing.xl),

            // Manual check button
            FiftyButton(
              label: 'CHECK CONNECTIVITY',
              onPressed: () => ConnectionActions.instance.checkConnectivity(),
              variant: FiftyButtonVariant.primary,
              icon: Icons.refresh,
              size: FiftyButtonSize.large,
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }
}
