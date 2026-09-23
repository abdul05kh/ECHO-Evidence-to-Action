import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/status_pill.dart';

void main() {
  group('StatusPill Widget Tests', () {
    testWidgets('renders APPROVED status pill correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusPill(status: 'approved'),
          ),
        ),
      );

      expect(find.text('APPROVED'), findsOneWidget);
    });

    testWidgets('renders READY FOR APPROVAL status pill correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusPill(status: 'ready'),
          ),
        ),
      );

      expect(find.text('READY FOR APPROVAL'), findsOneWidget);
    });

    testWidgets('renders IN PROGRESS status pill correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusPill(status: 'in_progress'),
          ),
        ),
      );

      expect(find.text('IN PROGRESS'), findsOneWidget);
    });

    testWidgets(
        'colorsForStatus static helper returns valid colors for all statuses',
        (WidgetTester tester) async {
      final statuses = [
        'draft',
        'processing',
        'needs_review',
        'ready',
        'approved',
        'assigned',
        'in_progress',
        'blocked',
        'completed',
        'reopened'
      ];
      for (final s in statuses) {
        final colors = StatusPill.colorsForStatus(s);
        expect(colors.bg, isNotNull);
        expect(colors.fg, isNotNull);
      }
    });
  });
}
