import 'dart:convert';

/// Validates raw JSON output from the AI model against the ActionPacket contract.
class SchemaValidator {
  static ValidationResult validate(dynamic rawJson) {
    if (rawJson == null) {
      return const ValidationResult(isValid: false, errorMessage: 'Output is null');
    }

    Map<String, dynamic> json;
    if (rawJson is String) {
      try {
        json = jsonDecode(rawJson) as Map<String, dynamic>;
      } catch (e) {
        return ValidationResult(isValid: false, errorMessage: 'Malformed JSON: $e');
      }
    } else if (rawJson is Map<String, dynamic>) {
      json = rawJson;
    } else {
      return const ValidationResult(isValid: false, errorMessage: 'Invalid JSON type');
    }

    // Required String fields
    final title = json['title'];
    if (title == null || title is! String || title.trim().isEmpty) {
      return const ValidationResult(isValid: false, errorMessage: 'Missing or empty required field: "title"');
    }

    final summary = json['summary'];
    if (summary == null || summary is! String || summary.trim().isEmpty) {
      return const ValidationResult(isValid: false, errorMessage: 'Missing or empty required field: "summary"');
    }

    final category = json['category'];
    if (category == null || category is! String) {
      return const ValidationResult(isValid: false, errorMessage: 'Missing required field: "category"');
    }

    // Validate arrays
    if (json['observations'] != null && json['observations'] is! List) {
      return const ValidationResult(isValid: false, errorMessage: '"observations" must be a list');
    }

    if (json['inferences'] != null && json['inferences'] is! List) {
      return const ValidationResult(isValid: false, errorMessage: '"inferences" must be a list');
    }

    if (json['missing_information'] != null && json['missing_information'] is! List) {
      return const ValidationResult(isValid: false, errorMessage: '"missing_information" must be a list');
    }

    if (json['suggested_actions'] != null && json['suggested_actions'] is! List) {
      return const ValidationResult(isValid: false, errorMessage: '"suggested_actions" must be a list');
    }

    if (json['checklist'] != null && json['checklist'] is! List) {
      return const ValidationResult(isValid: false, errorMessage: '"checklist" must be a list');
    }

    return ValidationResult(isValid: true, parsedData: json);
  }
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final Map<String, dynamic>? parsedData;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.parsedData,
  });
}
