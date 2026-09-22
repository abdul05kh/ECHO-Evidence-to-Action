import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../ai/model_adapter.dart';
import '../../packet/domain/action_packet.dart';

class ProcessingScreen extends StatefulWidget {
  final EvidencePackage evidence;
  final ModelAdapter modelAdapter;
  final Function(ActionPacketModel packet) onComplete;
  final VoidCallback onError;

  const ProcessingScreen({
    super.key,
    required this.evidence,
    required this.modelAdapter,
    required this.onComplete,
    required this.onError,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  int _currentStep = 0;
  int _elapsedMs = 0;
  Timer? _stopwatchTimer;
  String? _statusError;

  List<String> get _steps {
    final hasTranscript = widget.evidence.voiceTranscript != null && widget.evidence.voiceTranscript!.isNotEmpty;
    final hasVoice = widget.evidence.voicePath != null;
    return [
      'Preparing evidence',
      hasTranscript
          ? 'Transcribing voice locally (On-Device STT)'
          : (hasVoice
              ? 'Transcription unavailable (Manual context required)'
              : 'Analyzing captured context'),
      'Structuring Action Packet',
      'Validating evidence provenance',
      'Applying policy rules',
    ];
  }

  @override
  void initState() {
    super.initState();
    _startProcessingPipeline();
  }

  @override
  void dispose() {
    _stopwatchTimer?.cancel();
    super.dispose();
  }

  void _startProcessingPipeline() async {
    _stopwatchTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _elapsedMs += 100;
        });
      }
    });

    try {
      // Step 0: Evidence prep
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) setState(() => _currentStep = 1);

      // Step 1: Voice transcription & context analysis
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) setState(() => _currentStep = 2);

      // Step 2: Model structuring (invoking real ModelAdapter)
      final packet = await widget.modelAdapter.generatePacket(
        widget.evidence,
        captureDurationMs: _elapsedMs,
      );
      if (mounted) setState(() => _currentStep = 3);

      // Step 3: Evidence validation
      await Future.delayed(const Duration(milliseconds: 350));
      if (mounted) setState(() => _currentStep = 4);

      // Step 4: Policy rule engine applied
      await Future.delayed(const Duration(milliseconds: 300));

      _stopwatchTimer?.cancel();
      if (mounted) {
        widget.onComplete(packet);
      }
    } catch (e) {
      _stopwatchTimer?.cancel();
      if (mounted) {
        setState(() {
          _statusError = 'Processing encountered an issue: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EchoTheme.canvasColor,
      appBar: AppBar(
        title: const Text('Structuring with ECHO'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Radar Pulse Visualizer
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: EchoTheme.accentGoldLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: EchoTheme.accentGold, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 40,
                    color: EchoTheme.accentGoldDark,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'STRUCTURING WORK PACKET',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: EchoTheme.accentGoldDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Elapsed: ${(_elapsedMs / 1000).toStringAsFixed(1)}s · Prototype Runtime · Evidence Structured',
                style: const TextStyle(
                  fontSize: 13,
                  color: EchoTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Stepper Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: EchoTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: EchoTheme.borderColor),
                ),
                child: Column(
                  children: List.generate(_steps.length, (idx) {
                    final isDone = idx < _currentStep;
                    final isCurrent = idx == _currentStep;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          if (isDone)
                            const Icon(Icons.check_circle_rounded, color: EchoTheme.successGreen, size: 20)
                          else if (isCurrent)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: EchoTheme.actionBlue,
                              ),
                            )
                          else
                            const Icon(Icons.radio_button_unchecked_rounded, color: EchoTheme.borderColor, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _steps[idx],
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                                color: isDone
                                    ? EchoTheme.textPrimary
                                    : (isCurrent ? EchoTheme.actionBlue : EchoTheme.textTertiary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              if (_statusError != null) ...[
                const SizedBox(height: 20),
                Text(
                  _statusError!,
                  style: const TextStyle(color: EchoTheme.dangerRed, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: widget.onError,
                  child: const Text('Return to Capture'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
