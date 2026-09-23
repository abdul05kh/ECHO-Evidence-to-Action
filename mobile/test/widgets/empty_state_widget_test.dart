import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget Tests', () {
    testWidgets('renders title and subtitle correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'No Work Orders',
              subtitle: 'Captured issues will appear here.',
            ),
          ),
        ),
      );

      expect(find.text('No Work Orders'), findsOneWidget);
      expect(find.text('Captured issues will appear here.'), findsOneWidget);
    });

    testWidgets('renders action button and triggers callback on tap',
        (WidgetTester tester) async {
      bool actionTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'Empty Queue',
              subtitle: 'Tap button to refresh',
              actionLabel: 'Refresh',
              onActionPressed: () {
                actionTapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Refresh'), findsOneWidget);
      await tester.tap(find.text('Refresh'));
      await tester.pump();

      expect(actionTapped, isTrue);
    });
  });
}
