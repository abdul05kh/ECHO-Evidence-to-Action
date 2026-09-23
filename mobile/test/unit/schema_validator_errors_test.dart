import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/ai/schema_validator.dart';

void main() {
  group('SchemaValidator Error Generation & Edge Case Tests', () {
    test('tryParseJson detects malformed JSON string', () {
      final res = SchemaValidator.tryParseJson(
          '{"title": "Broken", summary: bad_json}');
      expect(res.isValid, isFalse);
      expect(res.errorMessage, contains('Malformed JSON string'));
    });

    test('validate detects missing title', () {
      final json = {
        'summary': 'Valid summary',
        'category': 'IT_PERIPHERAL',
      };
      final res = SchemaValidator.validate(json);
      expect(res.isValid, isFalse);
      expect(res.errorMessage,
          contains('Missing or empty required field: "title"'));
    });

    test('validate detects missing summary', () {
      final json = {
        'title': 'Valid title',
        'category': 'IT_PERIPHERAL',
      };
      final res = SchemaValidator.validate(json);
      expect(res.isValid, isFalse);
      expect(res.errorMessage,
          contains('Missing or empty required field: "summary"'));
    });

    test('validate detects invalid list fields', () {
      final json = {
        'title': 'Valid title',
        'summary': 'Valid summary',
        'category': 'IT_PERIPHERAL',
        'observations': 'not_a_list',
      };
      final res = SchemaValidator.validate(json);
      expect(res.isValid, isFalse);
      expect(res.errorMessage, contains('"observations" must be a list'));
    });
  });
}
