import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:fifty_socket_example/controllers/socket_controller.dart';
import 'package:fifty_socket_example/main.dart';

void main() {
  setUp(() {
    Get.put(SocketController());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const FiftySocketExampleApp());
    await tester.pump();

    expect(find.text('FIFTY SOCKET'), findsOneWidget);
  });
}
