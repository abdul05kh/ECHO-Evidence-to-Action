import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/packet/presentation/evidence_provenance_modal.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('EvidenceProvenanceModal Widget Tests', () {
    testWidgets('renders evidence provenance modal content correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => const EvidenceProvenanceModal(
                      statement: 'Captured photograph of desk keyboard.',
                      isObservation: true,
                      links: [
                        EvidenceLink(
                          evidenceId: 'PHOTO_001',
                          type: 'photo',
                          label: 'PHOTO_001',
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Show Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Modal'));
      await tester.pumpAndSettle();

      expect(find.text('EVIDENCE PROVENANCE'), findsOneWidget);
    });
  });
}
