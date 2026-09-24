import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/bridge/markdown_exporter.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('MarkdownExporter Unit Tests', () {
    final now = DateTime(2026, 9, 25, 12, 0, 0);

    test('exports ActionPacketModel to valid GitHub Flavored Markdown', () {
      final packet = ActionPacketModel(
        id: 'ap_md_01',
        title: 'HVAC Water Leak',
        category: 'equipment',
        priority: 'critical',
        priorityReason: 'Active flooding',
        summary: 'Supply valve ruptured on 2nd floor.',
        observations: [
          const ObservedFact(text: 'Water pooling near electrical conduit'),
        ],
        checklist: [
          const ChecklistItemData(
              id: 'c1', text: 'Shut off main water valve', isCompleted: true),
          const ChecklistItemData(
              id: 'c2', text: 'Notify facilities manager', isCompleted: false),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final md = MarkdownExporter.toMarkdown(packet);

      expect(md, contains('# ECHO Action Packet: HVAC Water Leak'));
      expect(md, contains('| **Packet ID** | `ap_md_01` |'));
      expect(md, contains('> Supply valve ruptured on 2nd floor.'));
      expect(md, contains('- [x] Shut off main water valve'));
      expect(md, contains('- [ ] Notify facilities manager'));
    });
  });
}
