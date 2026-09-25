import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/core/storage/evidence_storage_size_calculator.dart';

void main() {
  group('EvidenceStorageSizeCalculator Unit Tests', () {
    test('formats byte counts to human readable strings', () {
      expect(EvidenceStorageSizeCalculator.formatBytes(0), equals('0 B'));
      expect(EvidenceStorageSizeCalculator.formatBytes(512), equals('512 B'));
      expect(EvidenceStorageSizeCalculator.formatBytes(2048), equals('2.0 KB'));
      expect(
          EvidenceStorageSizeCalculator.formatBytes(5242880), equals('5.0 MB'));
      expect(EvidenceStorageSizeCalculator.formatBytes(3221225472),
          equals('3.00 GB'));
    });

    test('calculates cumulative storage total correctly', () {
      final sizes = [1024, 2048, 4096];
      final total =
          EvidenceStorageSizeCalculator.calculateTotalSizeBytes(sizes);
      expect(total, equals(7168));
      expect(
          EvidenceStorageSizeCalculator.formatBytes(total), equals('7.0 KB'));
    });
  });
}
