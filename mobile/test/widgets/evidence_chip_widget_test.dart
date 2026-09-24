import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/evidence_chip.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('EvidenceChip Widget Tests', () {
    testWidgets('renders photo evidence link chip correctly',
        (WidgetTester tester) async {
      const link = EvidenceLink(
          evidenceId: 'photo_1', type: 'photo', label: 'PHOTO_001');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EvidenceChip(link: link),
          ),
        ),
      );

      expect(find.text('PHOTO_001'), findsOneWidget);
      expect(find.byIcon(Icons.photo_camera_rounded), findsOneWidget);
    });

    testWidgets('renders voice evidence link chip with timestamp',
        (WidgetTester tester) async {
      const link = EvidenceLink(
          evidenceId: 'voice_1',
          type: 'voice',
          label: 'VOICE_001',
          timestampSec: 14);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EvidenceChip(link: link),
          ),
        ),
      );

      expect(find.text('VOICE_001'), findsOneWidget);
      expect(find.text('(14s)'), findsOneWidget);
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
    });

    testWidgets('renders ConfidenceChip with Verified state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ConfidenceChip(state: 'High Confidence'),
          ),
        ),
      );

      expect(find.text('High Confidence'), findsOneWidget);
      expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);
    });
  });
}
