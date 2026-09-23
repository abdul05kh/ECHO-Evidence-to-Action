import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/confirm_dialog.dart';

void main() {
  group('ConfirmDialog Widget Tests', () {
    testWidgets(
        'ConfirmDialog shows title, message, and returns true on confirm',
        (WidgetTester tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ConfirmDialog.show(
                    context,
                    title: 'Delete Task',
                    message: 'Are you sure you want to delete this task?',
                    confirmLabel: 'Delete',
                    isDanger: true,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Task'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this task?'),
          findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('ConfirmDialog returns false on cancel tap',
        (WidgetTester tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ConfirmDialog.show(
                    context,
                    title: 'Confirm Action',
                    message: 'Proceed with changes?',
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });
  });
}
