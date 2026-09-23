import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/ai/model_adapter.dart';
import 'package:echo_mobile/features/home/home_queue_screen.dart';

void main() {
  group('HomeQueueScreen Widget Tests', () {
    testWidgets('renders top app bar title and demo task card',
        (WidgetTester tester) async {
      final modelAdapter =
          EchoModelAdapter(currentMode: ModelRuntimeMode.prototypeRuntime);

      await tester.pumpWidget(
        MaterialApp(
          home: HomeQueueScreen(modelAdapter: modelAdapter),
        ),
      );

      expect(find.text('Field Orchestrator'), findsOneWidget);
      expect(find.text('+ CAPTURE ISSUE'), findsOneWidget);
      expect(find.text('ACTIVE WORK ORDERS'), findsOneWidget);
    });

    testWidgets('renders active work orders list or empty state correctly',
        (WidgetTester tester) async {
      final modelAdapter =
          EchoModelAdapter(currentMode: ModelRuntimeMode.prototypeRuntime);

      await tester.pumpWidget(
        MaterialApp(
          home: HomeQueueScreen(modelAdapter: modelAdapter),
        ),
      );

      expect(find.text('Lab 2 Projector Not Powering On'), findsOneWidget);
    });
  });
}
