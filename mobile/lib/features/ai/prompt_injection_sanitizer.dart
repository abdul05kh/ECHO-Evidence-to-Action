/// Result of prompt injection analysis.
class PromptSanitizationResult {
  final bool isSanitized;
  final bool hasInjectionRisk;
  final String originalText;
  final String sanitizedText;
  final List<String> detectedPatterns;

  const PromptSanitizationResult({
    required this.isSanitized,
    required this.hasInjectionRisk,
    required this.originalText,
    required this.sanitizedText,
    required this.detectedPatterns,
  });
}

/// Utility for detecting and sanitizing adversarial prompt injection attacks in user transcripts.
class PromptInjectionSanitizer {
  static const List<String> _adversarialPatterns = [
    r'ignore\s+previous\s+instructions',
    r'disregard\s+above',
    r'system:\s*override',
    r'you\s+are\s+now\s+unrestricted',
    r'forget\s+all\s+rules',
    r'developer\s+mode\s+enabled',
    r'jailbreak',
  ];

  /// Analyzes input text for adversarial prompt injection patterns and returns a sanitized result.
  static PromptSanitizationResult sanitize(String input) {
    if (input.trim().isEmpty) {
      return PromptSanitizationResult(
        isSanitized: false,
        hasInjectionRisk: false,
        originalText: input,
        sanitizedText: input,
        detectedPatterns: const [],
      );
    }

    String cleaned = input;
    final detected = <String>[];

    for (final patternStr in _adversarialPatterns) {
      final regExp = RegExp(patternStr, caseSensitive: false);
      if (regExp.hasMatch(cleaned)) {
        detected.add(patternStr);
        cleaned = cleaned.replaceAll(regExp, '[REDACTED_ADVERSARIAL_INPUT]');
      }
    }

    final hasRisk = detected.isNotEmpty;
    return PromptSanitizationResult(
      isSanitized: hasRisk,
      hasInjectionRisk: hasRisk,
      originalText: input,
      sanitizedText: cleaned,
      detectedPatterns: detected,
    );
  }
}
