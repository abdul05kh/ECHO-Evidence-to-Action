import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';
import '../../ai/model_adapter.dart';
import '../../packet/domain/action_packet.dart';
import '../../packet/presentation/action_packet_screen.dart';
import 'audio_recorder_widget.dart';
import 'camera_screen.dart';
import 'processing_screen.dart';
import '../domain/audio_transcriber.dart';

class CaptureView extends StatefulWidget {
  final ModelAdapter modelAdapter;
  final Function(ActionPacketModel approvedPacket) onPacketApproved;
  final VoidCallback onBack;

  const CaptureView({
    super.key,
    required this.modelAdapter,
    required this.onPacketApproved,
    required this.onBack,
  });

  @override
  State<CaptureView> createState() => _CaptureViewState();
}

class _CaptureViewState extends State<CaptureView> {
  String? _photoPath;
  String? _voicePath;
  int _voiceDurationSec = 0;
  TranscriptionResult? _transcriptionResult;
  final TextEditingController _notesController = TextEditingController();

  late DateTime _captureStartTime;
  bool _isDemoFixtureLoaded = false;
  CaptureMode _mode = CaptureMode.liveCapture;

  @override
  void initState() {
    super.initState();
    _captureStartTime = DateTime.now();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _openCamera() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          onPhotoCaptured: (path) {
            setState(() {
              _photoPath = path;
              _isDemoFixtureLoaded = false;
              _mode = CaptureMode.liveCapture;
            });
          },
        ),
      ),
    );
  }

  void _loadCanonicalDemoScenario() {
    setState(() {
      _notesController.text =
          'Lab 2 projector is not powering on. The next class starts in about 20 minutes. We have a spare cable in the equipment room.';
      _photoPath = 'assets/sample_data/projector_broken.jpg';
      _voiceDurationSec = 18;
      _isDemoFixtureLoaded = true;
      _mode = CaptureMode.demoFixture;
      _transcriptionResult = const TranscriptionResult(
        status: TranscriptionStatus.transcribed,
        transcript:
            'Lab 2 projector is not powering on. The next class starts in about 20 minutes. We have a spare cable in the equipment room.',
        language: 'en-US',
        durationMs: 18000,
        confidenceState: 'HIGH',
        runtime: TranscriptionRuntime.prototypeRuntime,
        source: TranscriptionSource.demoFixture,
        latencyMs: 1200,
      );
    });
  }

  void _startStructuring() {
    if (_photoPath == null &&
        _voicePath == null &&
        _notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please capture a photo, voice note, or text note before structuring.'),
          backgroundColor: EchoTheme.warningAmber,
        ),
      );
      return;
    }

    final now = DateTime.now();
    final actualCaptureDurationMs =
        now.difference(_captureStartTime).inMilliseconds;
    final rawText = _notesController.text.trim();
    final transcript = _transcriptionResult?.transcript ??
        (rawText.isNotEmpty ? rawText : null);

    final evidencePackage = EvidencePackage(
      mode: _mode,
      photoPath: _photoPath,
      voicePath: _voicePath,
      voiceDurationSec: _voiceDurationSec,
      voiceTranscript: transcript,
      textNotes: rawText.isNotEmpty ? rawText : null,
      capturedAt: _captureStartTime,
      captureSessionId: const Uuid().v4().substring(0, 8),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProcessingScreen(
          evidence: evidencePackage,
          modelAdapter: widget.modelAdapter,
          onComplete: (packet) {
            final packetWithActualDuration = packet.copyWith(
              captureDurationMs:
                  actualCaptureDurationMs > 0 ? actualCaptureDurationMs : 35000,
            );

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ActionPacketScreen(
                  packet: packetWithActualDuration,
                  localPhotoPath: _photoPath,
                  localVoicePath: _voicePath,
                  onApprove: (approvedPacket) {
                    Navigator.of(context).pop();
                    widget.onPacketApproved(approvedPacket);
                  },
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
          onError: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasEvidence = _photoPath != null ||
        _voicePath != null ||
        _notesController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: EchoTheme.canvasColor,
      appBar: AppBar(
        title: const Text('Capture Operational Issue'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
        actions: [
          // Clear demo scenario seed button
          TextButton.icon(
            onPressed: _loadCanonicalDemoScenario,
            icon: const Icon(Icons.science_rounded,
                size: 16, color: EchoTheme.accentGoldDark),
            label: const Text(
              'DEMO SCENARIO',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: EchoTheme.accentGoldDark,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_isDemoFixtureLoaded) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: EchoTheme.accentGoldLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EchoTheme.accentGoldDark),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 16, color: EchoTheme.accentGoldDark),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'DEMO SCENARIO LOADED · Lab 2 Projector canonical fixture active',
                      style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: EchoTheme.accentGoldDark),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 1. Visual Evidence Section
          _buildSectionTitle(
              '1. VISUAL EVIDENCE (PHOTO)', Icons.camera_alt_outlined),
          const SizedBox(height: 8),
          if (_photoPath != null) ...[
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: EchoTheme.secondarySurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: EchoTheme.borderColor),
                image: File(_photoPath!).existsSync()
                    ? DecorationImage(
                        image: FileImage(File(_photoPath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Photo Attached',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: EchoTheme.successGreen),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: _openCamera,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.refresh_rounded,
                              size: 18, color: EchoTheme.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => setState(() {
                          _photoPath = null;
                          _isDemoFixtureLoaded = false;
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.delete_outline_rounded,
                              size: 18, color: EchoTheme.dangerRed),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            InkWell(
              onTap: _openCamera,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: EchoTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: EchoTheme.borderColor),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined,
                        size: 32, color: EchoTheme.actionBlue),
                    SizedBox(height: 8),
                    Text(
                      'Take Photo of Issue',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: EchoTheme.actionBlue,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Real-time Android camera viewfinder',
                      style: TextStyle(
                          fontSize: 11.5, color: EchoTheme.textTertiary),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),

          // 2. Audio Evidence Section
          _buildSectionTitle(
              '2. SPOKEN CONTEXT (VOICE NOTE)', Icons.mic_none_outlined),
          const SizedBox(height: 8),
          AudioRecorderWidget(
            initialAudioPath: _voicePath,
            initialTranscriptionResult: _transcriptionResult,
            onRecordingComplete: (path, duration, result) {
              setState(() {
                _voicePath = path;
                _voiceDurationSec = duration;
                _transcriptionResult = result;
                _isDemoFixtureLoaded = false;
                if (result.isTranscribed &&
                    _notesController.text.trim().isEmpty) {
                  _notesController.text = result.transcript!;
                }
              });
            },
            onRecordingDeleted: () {
              setState(() {
                _voicePath = null;
                _voiceDurationSec = 0;
                _transcriptionResult = null;
              });
            },
          ),
          const SizedBox(height: 18),

          // 3. Spoken Transcript / Context Notes
          _buildSectionTitle(
              '3. SPOKEN TRANSCRIPT / CONTEXT NOTES', Icons.edit_note_outlined),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'e.g. The keyboard isn\'t working. Please fix it.',
              hintStyle:
                  const TextStyle(fontSize: 13, color: EchoTheme.textTertiary),
              filled: true,
              fillColor: EchoTheme.surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: EchoTheme.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: EchoTheme.borderColor),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: EchoTheme.surfaceColor,
          border: Border(top: BorderSide(color: EchoTheme.borderColor)),
        ),
        child: ElevatedButton(
          onPressed: hasEvidence ? _startStructuring : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: EchoTheme.accentGold,
            foregroundColor: EchoTheme.textPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            disabledBackgroundColor: EchoTheme.secondarySurface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 20,
                color: hasEvidence
                    ? EchoTheme.textPrimary
                    : EchoTheme.textTertiary,
              ),
              const SizedBox(width: 10),
              Text(
                'STRUCTURE WITH ECHO',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: hasEvidence
                      ? EchoTheme.textPrimary
                      : EchoTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 15, color: EchoTheme.textSecondary),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: EchoTheme.textSecondary,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
