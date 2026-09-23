import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/echo_loading_indicator.dart';

void main() {
  group('EchoLoadingIndicator Widget Tests', () {
    testWidgets('renders progress indicator without message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EchoLoadingIndicator(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders progress indicator with custom message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EchoLoadingIndicator(message: 'Processing Evidence...'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing Evidence...'), findsOneWidget);
    });
  });
}
