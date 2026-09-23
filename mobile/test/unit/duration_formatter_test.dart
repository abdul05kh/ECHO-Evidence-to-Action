import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/core/utils/duration_formatter.dart';

void main() {
  group('EchoDurationFormatter Unit Tests', () {
    test('formatMs handles null and 0 milliseconds', () {
      expect(EchoDurationFormatter.formatMs(null), equals('00:00'));
      expect(EchoDurationFormatter.formatMs(0), equals('00:00'));
      expect(EchoDurationFormatter.formatMs(-500), equals('00:00'));
    });

    test('formatMs formats 38000 milliseconds to "00:38"', () {
      expect(EchoDurationFormatter.formatMs(38000), equals('00:38'));
    });

    test('formatMs formats 125000 milliseconds to "02:05"', () {
      expect(EchoDurationFormatter.formatMs(125000), equals('02:05'));
    });

    test('formatSeconds formats 75 seconds to "01:15"', () {
      expect(EchoDurationFormatter.formatSeconds(75), equals('01:15'));
    });
  });
}
