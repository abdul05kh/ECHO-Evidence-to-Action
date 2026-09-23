import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/category_chip.dart';

void main() {
  group('CategoryChip Widget Tests', () {
    testWidgets('renders IT & Peripheral category chip',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryChip(category: 'it_peripheral'),
          ),
        ),
      );

      expect(find.text('IT & Peripheral'), findsOneWidget);
    });

    testWidgets('renders Electrical category chip',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryChip(category: 'electrical'),
          ),
        ),
      );

      expect(find.text('Electrical'), findsOneWidget);
    });

    testWidgets('renders HVAC category chip', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CategoryChip(category: 'hvac'),
          ),
        ),
      );

      expect(find.text('HVAC & Climate'), findsOneWidget);
    });
  });
}
