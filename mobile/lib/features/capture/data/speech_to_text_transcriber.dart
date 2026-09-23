import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../domain/audio_transcriber.dart';

class SpeechToTextTranscriber implements AudioTranscriber {
  static const MethodChannel _channel =
      MethodChannel('com.echo.orchestrator/native_stt');

  bool _isInitialized = false;
  bool _isOnDeviceAvailable = false;
  String _currentRecognizedWords = '';
  Function(String words)? _onPartialCallback;
  Completer<String>? _finalCompleter;

  SpeechToTextTranscriber() {
    _channel.setMethodCallHandler(_handleNativeCallback);
  }

  Future<void> _handleNativeCallback(MethodCall call) async {
    switch (call.method) {
      case 'onPartialResults':
        final text = (call.arguments['transcript'] as String?) ?? '';
        if (text.isNotEmpty) {
          _currentRecognizedWords = text;
          _onPartialCallback?.call(text);
        }
        break;
      case 'onResults':
        final text = (call.arguments['transcript'] as String?) ?? '';
        if (text.isNotEmpty) {
          _currentRecognizedWords = text;
          _onPartialCallback?.call(text);
        }
        if (_finalCompleter != null && !_finalCompleter!.isCompleted) {
          _finalCompleter!.complete(_currentRecognizedWords);
        }
        break;
      case 'onError':
        final error = call.arguments['errorMessage'] ?? 'Unknown STT error';
        debugPrint('Native STT error: $error');
        if (_finalCompleter != null && !_finalCompleter!.isCompleted) {
          _finalCompleter!.complete(_currentRecognizedWords);
        }
        break;
    }
  }

  @override
  bool get isAvailable => _isInitialized && _isOnDeviceAvailable;

  @override
  Future<bool> initialize() async {
    if (_isInitialized) return _isOnDeviceAvailable;
    if (!Platform.isAndroid) {
      _isInitialized = true;
      _isOnDeviceAvailable = false;
      return false;
    }
    try {
      final res = await _channel.invokeMethod<Map>('checkOnDeviceAvailability');
      _isOnDeviceAvailable = res?['isOnDeviceAvailable'] == true;
      _isInitialized = true;
      return _isOnDeviceAvailable;
    } catch (e) {
      debugPrint('Error initializing native STT: $e');
      _isInitialized = false;
      _isOnDeviceAvailable = false;
      return false;
    }
  }

  /// Starts listening using Android On-Device SpeechRecognizer
  Future<bool> startListening(
      {required Function(String words) onPartialResult,
      String locale = 'en-US'}) async {
    await initialize();
    _currentRecognizedWords = '';
    _onPartialCallback = onPartialResult;
    _finalCompleter = Completer<String>();

    try {
      final ok = await _channel
          .invokeMethod<bool>('startListening', {'locale': locale});
      return ok == true;
    } catch (e) {
      debugPrint('Error starting native STT: $e');
      return false;
    }
  }

  /// Stops listening and returns the finalized transcription result
  Future<TranscriptionResult> stopListening({int durationMs = 0}) async {
    final stopwatch = Stopwatch()..start();
    try {
      await _channel.invokeMethod('stopListening');
      if (_finalCompleter != null) {
        await _finalCompleter!.future.timeout(
          const Duration(milliseconds: 500),
          onTimeout: () => _currentRecognizedWords,
        );
      }
    } catch (e) {
      debugPrint('Error stopping native STT: $e');
    }
    stopwatch.stop();

    final recognized = _currentRecognizedWords.trim();
    if (recognized.isNotEmpty) {
      return TranscriptionResult(
        status: TranscriptionStatus.transcribed,
        transcript: recognized,
        language: 'en-US',
        durationMs: durationMs,
        confidenceState: 'HIGH',
        runtime: TranscriptionRuntime.localDeviceRuntime,
        source: TranscriptionSource.localAudio,
        latencyMs: stopwatch.elapsedMilliseconds,
        engine: 'ON-DEVICE RECOGNITION SERVICE',
      );
    } else {
      return TranscriptionResult.unavailable(
        reason: 'NO_SPEECH_DETECTED',
        latencyMs: stopwatch.elapsedMilliseconds,
      );
    }
  }

  @override
  Future<TranscriptionResult> transcribe(String audioPath) async {
    if (_currentRecognizedWords.trim().isNotEmpty) {
      return TranscriptionResult(
        status: TranscriptionStatus.transcribed,
        transcript: _currentRecognizedWords.trim(),
        language: 'en-US',
        confidenceState: 'HIGH',
        runtime: TranscriptionRuntime.localDeviceRuntime,
        source: TranscriptionSource.localAudio,
        latencyMs: 120,
        engine: 'ON-DEVICE RECOGNITION SERVICE',
      );
    }
    return TranscriptionResult.unavailable(
        reason: 'OFFLINE_FILE_TRANSCRIPTION_UNSUPPORTED');
  }
}
