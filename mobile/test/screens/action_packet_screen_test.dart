import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/packet/presentation/action_packet_screen.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('ActionPacketScreen Widget Tests', () {
    testWidgets('renders ActionPacketScreen title and approval button',
        (WidgetTester tester) async {
      final packet = ActionPacketModel(
        id: 'ap_test_100',
        title: 'Test Keyboard Failure',
        category: 'IT_PERIPHERAL',
        priority: 'high',
        priorityReason: 'User unable to work',
        summary: 'Keyboard not working on desk 4.',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ActionPacketScreen(
            packet: packet,
            onApprove: (_) {},
            onCancel: () {},
          ),
        ),
      );

      expect(find.text('Test Keyboard Failure'), findsOneWidget);
      expect(find.text('APPROVE WORK ORDER'), findsOneWidget);
    });
  });
}
