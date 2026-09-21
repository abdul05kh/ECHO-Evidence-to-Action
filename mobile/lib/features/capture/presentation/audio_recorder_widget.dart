import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';

class AudioRecorderWidget extends StatefulWidget {
  final Function(String path, int durationSec) onRecordingComplete;
  final VoidCallback onRecordingDeleted;
  final String? initialAudioPath;

  const AudioRecorderWidget({
    super.key,
    required this.onRecordingComplete,
    required this.onRecordingDeleted,
    this.initialAudioPath,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  late final AudioRecorder _audioRecorder;
  late final AudioPlayer _audioPlayer;

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _audioPath;
  int _recordDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();
    _audioPath = widget.initialAudioPath;

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
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

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
          path: path,
        );

        setState(() {
          _isRecording = true;
          _recordDuration = 0;
          _audioPath = null;
        });

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
      final path = await _audioRecorder.stop();
      if (path != null) {
        setState(() {
          _isRecording = false;
          _audioPath = path;
        });
        widget.onRecordingComplete(path, _recordDuration);
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
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
    });
    widget.onRecordingDeleted();
  }

  @override
  Widget build(BuildContext context) {
    if (_audioPath != null) {
      // Audio Recorded State
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: EchoTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EchoTheme.borderColor),
        ),
        child: Row(
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
                  const Text(
                    'Voice Note Recorded',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: EchoTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '${_recordDuration > 0 ? _recordDuration : 18}s · AAC Audio (Local)',
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
        child: Row(
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
