import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/bridge/csv_exporter.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('CSVExporter Unit Tests', () {
    final now = DateTime(2026, 9, 25, 12, 0, 0);

    test('escapes special characters like commas and quotes in CSV fields', () {
      expect(CSVExporter.escapeCsv('Simple Text'), 'Simple Text');
      expect(CSVExporter.escapeCsv('Text, with comma'), '"Text, with comma"');
      expect(CSVExporter.escapeCsv('Text with "quotes"'),
          '"Text with ""quotes"""');
    });

    test('generates full CSV document with header and rows', () {
      final packet1 = ActionPacketModel(
        id: 'ap_csv_01',
        title: 'Projector Defective',
        category: 'equipment',
        priority: 'high',
        priorityReason: 'Class in session',
        summary: 'Unit overheating.',
        createdAt: now,
        updatedAt: now,
      );

      final packet2 = ActionPacketModel(
        id: 'ap_csv_02',
        title: 'Door Latch, Broken',
        category: 'facility',
        priority: 'low',
        priorityReason: 'Cosmetic',
        summary: 'Latch sticky.',
        createdAt: now,
        updatedAt: now,
      );

      final doc = CSVExporter.toCsvDocument([packet1, packet2]);

      expect(
          doc,
          contains(
              'id,title,category,priority,status,confidence_state,created_at,summary'));
      expect(
          doc,
          contains(
              'ap_csv_01,Projector Defective,equipment,high,draft,High Confidence'));
      expect(
          doc,
          contains(
              'ap_csv_02,"Door Latch, Broken",facility,low,draft,High Confidence'));
    });
  });
}
