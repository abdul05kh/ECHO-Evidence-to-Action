import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/status_pill.dart';
import '../data/speech_to_text_transcriber.dart';
import '../domain/audio_transcriber.dart';

class AudioRecorderWidget extends StatefulWidget {
  final Function(String path, int durationSec, TranscriptionResult transcriptionResult) onRecordingComplete;
  final VoidCallback onRecordingDeleted;
  final String? initialAudioPath;
  final TranscriptionResult? initialTranscriptionResult;

  const AudioRecorderWidget({
    super.key,
    required this.onRecordingComplete,
    required this.onRecordingDeleted,
    this.initialAudioPath,
    this.initialTranscriptionResult,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  late final AudioRecorder _audioRecorder;
  late final AudioPlayer _audioPlayer;
  late final SpeechToTextTranscriber _transcriber;

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _audioPath;
  int _recordDuration = 0;
  Timer? _timer;
  String _liveTranscript = '';
  TranscriptionResult? _transcriptionResult;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();
    _transcriber = SpeechToTextTranscriber();
    _audioPath = widget.initialAudioPath;
    _transcriptionResult = widget.initialTranscriptionResult;

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    // Warm up STT engine early
    _transcriber.initialize();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final docsDir = await getApplicationDocumentsDirectory();
        final path = p.join(docsDir.path, 'voice_${const Uuid().v4().substring(0, 8)}.m4a');

        setState(() {
          _isRecording = true;
          _recordDuration = 0;
          _audioPath = null;
          _liveTranscript = '';
          _transcriptionResult = null;
        });

        // Start local native STT
        await _transcriber.startListening(
          onPartialResult: (words) {
            if (mounted) {
              setState(() {
                _liveTranscript = words;
              });
            }
          },
        );

        try {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
            path: path,
          );
        } catch (e) {
          debugPrint('Audio recorder start warning: $e');
        }

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              _recordDuration++;
            });
          }
        });
      }
    } catch (e) {
      debugPrint('Error starting audio recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    try {
      String? path;
      try {
        path = await _audioRecorder.stop();
      } catch (e) {
        debugPrint('Audio recorder stop warning: $e');
      }

      final result = await _transcriber.stopListening(durationMs: _recordDuration * 1000);

      // Fallback path if path was not returned by recorder but was specified
      final finalPath = path ?? _audioPath;

      setState(() {
        _isRecording = false;
        _audioPath = finalPath;
        _transcriptionResult = result;
      });

      if (finalPath != null) {
        widget.onRecordingComplete(finalPath, _recordDuration, result);
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _togglePlayback() async {
    if (_audioPath == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(_audioPath!));
    }
  }

  void _deleteRecording() {
    if (_audioPath != null) {
      final file = File(_audioPath!);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    setState(() {
      _audioPath = null;
      _recordDuration = 0;
      _isPlaying = false;
      _liveTranscript = '';
      _transcriptionResult = null;
    });
    widget.onRecordingDeleted();
  }

  @override
  Widget build(BuildContext context) {
    if (_audioPath != null) {
      final isTranscribed = _transcriptionResult?.isTranscribed == true;
      final transcriptText = _transcriptionResult?.transcript ?? '';

      // Audio Recorded State
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: EchoTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EchoTheme.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: _togglePlayback,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: EchoTheme.actionBlueLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: EchoTheme.actionBlue,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'VOICE NOTE #01',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: EchoTheme.textPrimary,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isTranscribed)
                            const StatusPill(status: 'transcribed', customLabel: 'TRANSCRIBED')
                          else
                            const StatusPill(status: 'needs_review', customLabel: 'TRANSCRIPTION UNAVAILABLE'),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${_recordDuration > 0 ? _recordDuration : 3}s · ${isTranscribed ? "Local On-Device STT · High Confidence" : "Audio captured · Add text notes below if needed"}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: EchoTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: EchoTheme.dangerRed),
                  onPressed: _deleteRecording,
                  tooltip: 'Delete Voice Note',
                ),
              ],
            ),
            if (isTranscribed) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: EchoTheme.secondarySurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: EchoTheme.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '"$transcriptText"',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: EchoTheme.textPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.memory_rounded, size: 12, color: EchoTheme.textTertiary),
                        SizedBox(width: 4),
                        Text(
                          'Runtime: LOCAL DEVICE RUNTIME',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: EchoTheme.textTertiary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (_isRecording) {
      // Active Recording State
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: EchoTheme.dangerRedLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EchoTheme.dangerRed.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: EchoTheme.dangerRed,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'RECORDING: 00:${_recordDuration.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: EchoTheme.dangerRed,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _stopRecording,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EchoTheme.dangerRed,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('STOP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            if (_liveTranscript.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Live STT: "$_liveTranscript"',
                style: const TextStyle(
                  fontSize: 12,
                  color: EchoTheme.textPrimary,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      );
    }

    // Default Idle State
    return InkWell(
      onTap: _startRecording,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: EchoTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EchoTheme.borderColor),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic_rounded, color: EchoTheme.actionBlue, size: 20),
            SizedBox(width: 8),
            Text(
              'Record Spoken Context (Voice Note)',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: EchoTheme.actionBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
