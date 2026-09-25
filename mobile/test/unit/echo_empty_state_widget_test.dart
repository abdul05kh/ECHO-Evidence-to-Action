import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/echo_empty_state_widget.dart';

void main() {
  group('EchoEmptyStateWidget Widget Tests', () {
    testWidgets('renders icon, title, and subtitle correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EchoEmptyStateWidget(
              icon: Icons.inbox_rounded,
              title: 'No Items Available',
              subtitle: 'Check back later for updates',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox_rounded), findsOneWidget);
      expect(find.text('No Items Available'), findsOneWidget);
      expect(find.text('Check back later for updates'), findsOneWidget);
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('renders action button and handles tap callback',
        (WidgetTester tester) async {
      bool actionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EchoEmptyStateWidget(
              icon: Icons.search_off_rounded,
              title: 'No Search Results',
              subtitle: 'Try adjusting your filters',
              actionLabel: 'Reset Filters',
              onActionPressed: () {
                actionTapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Reset Filters'), findsOneWidget);
      await tester.tap(find.text('Reset Filters'));
      await tester.pump();

      expect(actionTapped, isTrue);
    });
  });
}
