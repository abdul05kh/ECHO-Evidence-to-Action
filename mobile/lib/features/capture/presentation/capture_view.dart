import 'dart:io';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../ai/model_adapter.dart';
import '../../packet/domain/action_packet.dart';
import 'audio_recorder_widget.dart';
import 'camera_screen.dart';
import 'processing_screen.dart';
import '../presentation/../packet/presentation/action_packet_screen.dart';

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
  final TextEditingController _notesController = TextEditingController();

  DateTime _captureStartTime = DateTime.now();

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
      MaterialBarPageRoute(
        builder: (context) => CameraScreen(
          onPhotoCaptured: (path) {
            setState(() {
              _photoPath = path;
            });
          },
        ),
      ),
    );
  }

  void _loadCanonicalDemoScenario() {
    setState(() {
      _notesController.text = 'Lab 2 projector is not powering on. The next class starts in about 20 minutes. We have a spare cable in the equipment room.';
      _photoPath = 'assets/sample_data/projector_broken.jpg'; // Canonical photo marker
      _voiceDurationSec = 18;
    });
  }

  void _startStructuring() {
    if (_photoPath == null && _voicePath == null && _notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture a photo, voice note, or text note before structuring.'),
          backgroundColor: EchoTheme.warningAmber,
        ),
      );
      return;
    }

    final evidencePackage = EvidencePackage(
      photoPath: _photoPath,
      voicePath: _voicePath,
      voiceDurationSec: _voiceDurationSec,
      voiceTranscript: _voicePath != null ? null : _notesController.text.trim(),
      textNotes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      capturedAt: _captureStartTime,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProcessingScreen(
          evidence: evidencePackage,
          modelAdapter: widget.modelAdapter,
          onComplete: (packet) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ActionPacketScreen(
                  packet: packet,
                  localPhotoPath: _photoPath,
                  localVoicePath: _voicePath,
                  onApprove: (approvedPacket) {
                    Navigator.of(context).pop(); // pop packet screen
                    Navigator.of(context).pop(); // pop capture screen
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
    final hasEvidence = _photoPath != null || _voicePath != null || _notesController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: EchoTheme.canvasColor,
      appBar: AppBar(
        title: const Text('Capture Operational Issue'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
        actions: [
          // Quick canonical seed button for hackathon testing
          TextButton.icon(
            onPressed: _loadCanonicalDemoScenario,
            icon: const Icon(Icons.flash_on_rounded, size: 16, color: EchoTheme.accentGoldDark),
            label: const Text(
              'Lab 2 Scenario',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: EchoTheme.accentGoldDark,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: EchoTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: EchoTheme.borderColor),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 20, color: EchoTheme.actionBlue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Capture what you see & say. ECHO structures it on-device into an Action Packet.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: EchoTheme.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 1. Visual Evidence Section
          _buildSectionTitle('1. VISUAL EVIDENCE (PHOTO)', Icons.camera_alt_outlined),
          const SizedBox(height: 8),
          if (_photoPath != null) ...[
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: EchoTheme.secondarySurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: EchoTheme.borderColor),
                image: _photoPath!.startsWith('assets/')
                    ? const DecorationImage(
                        image: AssetImage('assets/sample_data/projector_broken.jpg'),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: FileImage(File(_photoPath!)),
                        fit: BoxFit.cover,
                      ),
              ),
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Photo Attached',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: EchoTheme.successGreen),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: _openCamera,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.refresh_rounded, size: 18, color: EchoTheme.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => setState(() => _photoPath = null),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.delete_outline_rounded, size: 18, color: EchoTheme.dangerRed),
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
                  border: Border.all(color: EchoTheme.borderColor, style: BorderStyle.solid),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, size: 32, color: EchoTheme.actionBlue),
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
                      style: TextStyle(fontSize: 11.5, color: EchoTheme.textTertiary),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),

          // 2. Audio Evidence Section
          _buildSectionTitle('2. SPOKEN CONTEXT (VOICE NOTE)', Icons.mic_none_outlined),
          const SizedBox(height: 8),
          AudioRecorderWidget(
            initialAudioPath: _voicePath,
            onRecordingComplete: (path, duration) {
              setState(() {
                _voicePath = path;
                _voiceDurationSec = duration;
              });
            },
            onRecordingDeleted: () {
              setState(() {
                _voicePath = null;
                _voiceDurationSec = 0;
              });
            },
          ),
          const SizedBox(height: 18),

          // 3. Optional Text Notes
          _buildSectionTitle('3. ADDITIONAL NOTES (OPTIONAL)', Icons.edit_note_outlined),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'e.g. Next class starts in 20 min, spare cable in room B...',
              hintStyle: const TextStyle(fontSize: 13, color: EchoTheme.textTertiary),
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
                color: hasEvidence ? EchoTheme.textPrimary : EchoTheme.textTertiary,
              ),
              const SizedBox(width: 10),
              Text(
                'STRUCTURE WITH ECHO',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: hasEvidence ? EchoTheme.textPrimary : EchoTheme.textTertiary,
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

class MaterialBarPageRoute<T> extends MaterialPageRoute<T> {
  MaterialBarPageRoute({required super.builder});
}
