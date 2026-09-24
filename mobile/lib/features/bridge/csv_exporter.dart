import '../packet/domain/action_packet.dart';

/// Exporter utility for transforming Action Packet records into CSV strings.
class CSVExporter {
  /// Standard CSV header row.
  static const String csvHeader =
      'id,title,category,priority,status,confidence_state,created_at,summary';

  /// Escapes CSV field values containing commas, quotes, or newlines.
  static String escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      final escaped = value.replaceAll('"', '""');
      return '"$escaped"';
    }
    return value;
  }

  /// Converts a single [ActionPacketModel] into a CSV row string.
  static String toRow(ActionPacketModel packet) {
    final fields = [
      escapeCsv(packet.id),
      escapeCsv(packet.title),
      escapeCsv(packet.category),
      escapeCsv(packet.priority),
      escapeCsv(packet.status),
      escapeCsv(packet.confidenceState),
      escapeCsv(packet.createdAt.toIso8601String()),
      escapeCsv(packet.summary),
    ];
    return fields.join(',');
  }

  /// Converts a list of [ActionPacketModel] items into a full CSV document.
  static String toCsvDocument(List<ActionPacketModel> packets) {
    final sb = StringBuffer();
    sb.writeln(csvHeader);
    for (final p in packets) {
      sb.writeln(toRow(p));
    }
    return sb.toString();
  }
}
