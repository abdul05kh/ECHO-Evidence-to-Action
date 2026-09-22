/// Architectural contract for offline speech-to-text transcription in ECHO.
library;

enum TranscriptionStatus {
  transcribed,
  unavailable,
  error,
}

enum TranscriptionRuntime {
  localDeviceRuntime,
  prototypeRuntime,
  deterministicFallback,
}

enum TranscriptionSource {
  localAudio,
  userEnteredText,
  demoFixture,
  none,
}

class TranscriptionResult {
  final TranscriptionStatus status;
  final String? transcript;
  final String? language;
  final int? durationMs;
  final String confidenceState;
  final TranscriptionRuntime runtime;
  final TranscriptionSource source;
  final int latencyMs;
  final String? errorCode;
  final String? engine;

  const TranscriptionResult({
    required this.status,
    this.transcript,
    this.language,
    this.durationMs,
    required this.confidenceState,
    required this.runtime,
    required this.source,
    required this.latencyMs,
    this.errorCode,
    this.engine,
  });

  bool get isTranscribed =>
      status == TranscriptionStatus.transcribed &&
      transcript != null &&
      transcript!.trim().isNotEmpty;

  static TranscriptionResult unavailable({String? reason, int latencyMs = 0}) {
    return TranscriptionResult(
      status: TranscriptionStatus.unavailable,
      transcript: null,
      language: 'en-US',
      confidenceState: 'NEEDS REVIEW',
      runtime: TranscriptionRuntime.localDeviceRuntime,
      source: TranscriptionSource.none,
      latencyMs: latencyMs,
      errorCode: reason ?? 'TRANSCRIPTION_UNAVAILABLE',
      engine: 'Android System Intelligence / Private Compute Core',
    );
  }

  static TranscriptionResult userProvided(String text, {int latencyMs = 0}) {
    return TranscriptionResult(
      status: TranscriptionStatus.transcribed,
      transcript: text.trim(),
      language: 'en-US',
      confidenceState: 'HIGH',
      runtime: TranscriptionRuntime.prototypeRuntime,
      source: TranscriptionSource.userEnteredText,
      latencyMs: latencyMs,
      engine: 'Manual Operator Text',
    );
  }
}

abstract class AudioTranscriber {
  Future<TranscriptionResult> transcribe(String audioPath);
  Future<bool> initialize();
  bool get isAvailable;
}
