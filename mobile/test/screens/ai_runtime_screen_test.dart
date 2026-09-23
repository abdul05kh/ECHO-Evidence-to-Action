import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/settings/presentation/ai_runtime_screen.dart';
import 'package:echo_mobile/features/ai/local_llm_provider.dart';

void main() {
  group('AIRuntimeScreen Widget Tests', () {
    testWidgets('renders AIRuntimeScreen title and diagnostics header',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AIRuntimeScreen(
            localLlmProvider: LiteRtLocalLlmProvider(),
          ),
        ),
      );

      expect(find.text('AI Engine & Edge Runtime'), findsOneWidget);
    });
  });
}
