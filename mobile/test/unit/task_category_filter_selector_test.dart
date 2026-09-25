import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/task_category_filter_selector.dart';

void main() {
  group('TaskCategoryFilterSelector Widget Tests', () {
    testWidgets('renders all category chips correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCategoryFilterSelector(
              categories: const ['equipment', 'electrical', 'plumbing'],
              selectedCategory: null,
              onCategorySelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('All Categories'), findsOneWidget);
      expect(find.text('EQUIPMENT'), findsOneWidget);
      expect(find.text('ELECTRICAL'), findsOneWidget);
      expect(find.text('PLUMBING'), findsOneWidget);
    });

    testWidgets('triggers callback when category chip selected',
        (WidgetTester tester) async {
      String? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCategoryFilterSelector(
              categories: const ['equipment', 'electrical'],
              selectedCategory: null,
              onCategorySelected: (cat) {
                selected = cat;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('EQUIPMENT'));
      await tester.pump();

      expect(selected, equals('equipment'));
    });
  });
}
