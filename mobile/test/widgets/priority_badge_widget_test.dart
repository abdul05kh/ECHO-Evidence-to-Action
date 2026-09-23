import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/priority_badge.dart';

void main() {
  group('PriorityBadge Widget Tests', () {
    testWidgets('renders CRITICAL priority badge correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriorityBadge(priority: 'critical'),
          ),
        ),
      );

      expect(find.text('CRITICAL'), findsOneWidget);
    });

    testWidgets('renders HIGH priority badge correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriorityBadge(priority: 'high'),
          ),
        ),
      );

      expect(find.text('HIGH'), findsOneWidget);
    });

    testWidgets('renders MEDIUM priority badge correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriorityBadge(priority: 'medium'),
          ),
        ),
      );

      expect(find.text('MEDIUM'), findsOneWidget);
    });

    testWidgets('renders LOW priority fallback badge correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriorityBadge(priority: 'unknown'),
          ),
        ),
      );

      expect(find.text('LOW'), findsOneWidget);
    });
  });
}
