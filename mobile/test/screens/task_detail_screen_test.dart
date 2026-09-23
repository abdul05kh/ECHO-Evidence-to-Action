import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';
import 'package:echo_mobile/features/tasks/presentation/task_detail_screen.dart';

void main() {
  group('TaskDetailScreen Widget Tests', () {
    final samplePacket = ActionPacketModel(
      id: 'ap_detail_101',
      title: 'Lab 2 Projector Power Issue',
      category: 'equipment',
      priority: 'high',
      priorityReason: 'Upcoming class in 20 minutes',
      summary: 'Projector unit is not powering on.',
      checklist: const [
        ChecklistItemData(id: 'chk_1', text: 'Inspect power cable seating'),
        ChecklistItemData(id: 'chk_2', text: 'Confirm wall switch is ON'),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    testWidgets('renders task title, status, and checklist items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TaskDetailScreen(
            packet: samplePacket,
            onTaskUpdated: (_) {},
          ),
        ),
      );

      expect(find.text('Lab 2 Projector Power Issue'),
          findsNWidgets(2)); // AppBar + Body card
      expect(find.text('OPERATIONAL CHECKLIST'), findsOneWidget);
      expect(find.text('Inspect power cable seating'), findsOneWidget);
      expect(find.text('Confirm wall switch is ON'), findsOneWidget);
    });

    testWidgets('toggles checklist item checkbox on tap',
        (WidgetTester tester) async {
      ActionPacketModel? updatedPacket;

      await tester.pumpWidget(
        MaterialApp(
          home: TaskDetailScreen(
            packet: samplePacket,
            onTaskUpdated: (p) {
              updatedPacket = p;
            },
          ),
        ),
      );

      await tester.tap(find.text('Inspect power cable seating'));
      await tester.pumpAndSettle();

      expect(updatedPacket, isNotNull);
      expect(updatedPacket!.checklist.first.isCompleted, isTrue);
    });
  });
}
