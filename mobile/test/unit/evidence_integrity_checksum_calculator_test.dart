import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/core/storage/evidence_integrity_checksum_calculator.dart';

void main() {
  group('EvidenceIntegrityChecksumCalculator Unit Tests', () {
    test('computes deterministic SHA-256 hash for byte array', () {
      final bytes = [101, 99, 104, 111]; // "echo"
      final checksum = EvidenceIntegrityChecksumCalculator.computeSha256(bytes);

      expect(checksum.length, equals(64));
      expect(
          checksum,
          equals(
              EvidenceIntegrityChecksumCalculator.computeStringSha256('echo')));
    });

    test('verifies integrity matching expected checksum', () {
      final bytes = [1, 2, 3, 4, 5];
      final checksum = EvidenceIntegrityChecksumCalculator.computeSha256(bytes);

      expect(
          EvidenceIntegrityChecksumCalculator.verifyIntegrity(bytes, checksum),
          isTrue);
      expect(
          EvidenceIntegrityChecksumCalculator.verifyIntegrity(
              bytes, 'invalid_checksum'),
          isFalse);
    });
  });
}
