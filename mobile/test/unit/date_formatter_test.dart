import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/core/utils/date_formatter.dart';

void main() {
  group('EchoDateFormatter Unit Tests', () {
    test('formatRelative returns "Just now" for recent timestamps', () {
      final now = DateTime.now();
      expect(EchoDateFormatter.formatRelative(now), equals('Just now'));
    });

    test('formatRelative returns "5 mins ago" for 5 minutes past', () {
      final past = DateTime.now().subtract(const Duration(minutes: 5));
      expect(EchoDateFormatter.formatRelative(past), equals('5 mins ago'));
    });

    test('formatRelative returns "2 hrs ago" for 2 hours past', () {
      final past = DateTime.now().subtract(const Duration(hours: 2));
      expect(EchoDateFormatter.formatRelative(past), equals('2 hrs ago'));
    });

    test('formatFull returns formatted date and time string', () {
      final dt = DateTime(2026, 9, 24, 14, 30);
      final formatted = EchoDateFormatter.formatFull(dt);
      expect(formatted, contains('2026'));
      expect(formatted, contains('Sep'));
    });
  });
}
