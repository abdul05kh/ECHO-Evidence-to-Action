import 'dart:convert';
import 'package:crypto/crypto.dart';

class EvidenceIntegrityChecksumCalculator {
  static String computeSha256(List<int> bytes) {
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String computeStringSha256(String text) {
    final bytes = utf8.encode(text);
    return computeSha256(bytes);
  }

  static bool verifyIntegrity(List<int> bytes, String expectedChecksum) {
    final calculated = computeSha256(bytes);
    return calculated.toLowerCase() == expectedChecksum.toLowerCase();
  }
}
