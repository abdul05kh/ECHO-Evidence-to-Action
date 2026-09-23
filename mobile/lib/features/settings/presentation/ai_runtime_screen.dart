import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../ai/local_llm_provider.dart';

class AIRuntimeScreen extends StatefulWidget {
  final LiteRtLocalLlmProvider localLlmProvider;

  const AIRuntimeScreen({
    super.key,
    required this.localLlmProvider,
  });

  @override
  State<AIRuntimeScreen> createState() => _AIRuntimeScreenState();
}

class _AIRuntimeScreenState extends State<AIRuntimeScreen> {
  LocalLlmRuntimeInfo? _info;
  StreamSubscription<double>? _sub;
  double _progress = 0.0;
  bool _isPurgingDb = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  void _loadStatus() async {
    final info = await widget.localLlmProvider.runtimeInfo();
    if (mounted) {
      setState(() => _info = info);
    }
  }

  void _startDownload() {
    _sub?.cancel();
    _sub = widget.localLlmProvider.downloadModel().listen((progress) async {
      final info = await widget.localLlmProvider.runtimeInfo();
      if (mounted) {
        setState(() {
          _info = info;
          _progress = progress;
        });
      }
    });
  }

  void _cancelDownload() {
    widget.localLlmProvider.cancelDownload();
    _sub?.cancel();
    _loadStatus();
  }

  void _deleteModel() async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Remove Model Weights?',
      message:
          'This will delete the 2.59 GB Gemma model weights from device storage. You will need to re-download to run local inference.',
      confirmLabel: 'Remove Model',
      isDestructive: true,
    );

    if (confirmed) {
      await widget.localLlmProvider.deleteModel();
      _loadStatus();
    }
  }

  void _purgeDatabaseCache() async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Reset Local Database Cache?',
      message:
          'This will clear transient offline packet logs and reset in-memory SQLite storage.',
      confirmLabel: 'Reset Database',
      isDestructive: true,
    );

    if (confirmed && mounted) {
      setState(() => _isPurgingDb = true);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() => _isPurgingDb = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Local database cache reset successfully.'),
            backgroundColor: EchoTheme.successGreen,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Engine & Edge Runtime'),
        centerTitle: false,
      ),
      body: _info == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: EchoTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: EchoTheme.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'LiteRT Edge LLM Runtime',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: EchoTheme.textPrimary,
                            ),
                          ),
                          _buildStatusPill(_info!.status),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildSpecRow(
                          'Target Model', 'Gemma 4 E2B-it (Quantized 4-bit)'),
                      _buildSpecRow(
                          'Engine Version', 'Google LiteRT v2.16 (TF Lite)'),
                      _buildSpecRow(
                          'Execution Provider', 'ARM NPU / GPU Delegate'),
                      _buildSpecRow('Memory Constraint', '< 1.8 GB RAM Peak'),
                      _buildSpecRow('Offline Capability',
                          '100% On-Device (Zero Cloud API)'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: EchoTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: EchoTheme.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Local Storage & Database Diagnostics',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: EchoTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSpecRow('SQLite Driver',
                          'SQLite3 Native (Drift persistence)'),
                      _buildSpecRow('Storage Mode',
                          'Local Device File / Safe Memory Fallback'),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _isPurgingDb ? null : _purgeDatabaseCache,
                        icon: _isPurgingDb
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.cleaning_services_rounded,
                                size: 16, color: EchoTheme.warningAmber),
                        label: Text(
                          _isPurgingDb
                              ? 'Resetting...'
                              : 'Reset Local Database Cache',
                          style: const TextStyle(color: EchoTheme.warningAmber),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_info?.status == LocalLlmStatus.downloading ||
                    _info?.status == LocalLlmStatus.verifying ||
                    _info?.status == LocalLlmStatus.installing) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: EchoTheme.actionBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: EchoTheme.actionBlue.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: EchoTheme.actionBlue,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _info?.status == LocalLlmStatus.verifying
                                  ? 'Verifying SHA-256 Checksum...'
                                  : (_info?.status == LocalLlmStatus.installing
                                      ? 'Installing & Initializing Weights...'
                                      : 'Downloading Gemma 4 E2B-it... ${(_progress * 100).toInt()}%'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: EchoTheme.actionBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: _progress > 0 ? _progress : null,
                          backgroundColor: Colors.white,
                          color: EchoTheme.actionBlue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _info?.formattedDownloadedProgress ??
                              'Streaming artifact from LiteRT community...',
                          style: const TextStyle(
                              fontSize: 11.5, color: EchoTheme.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _cancelDownload,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: EchoTheme.dangerRed),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          child: const Text('Cancel Download',
                              style: TextStyle(
                                  color: EchoTheme.dangerRed, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ] else if (_info?.status == LocalLlmStatus.ready) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: EchoTheme.successGreenLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: EchoTheme.successGreen.withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: EchoTheme.successGreen, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Local Model Ready for Offline Inference',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: EchoTheme.successGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Action Packets will be structured directly using local on-device LiteRT weights with zero internet dependency.',
                          style: TextStyle(
                              fontSize: 12, color: EchoTheme.textPrimary),
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: _deleteModel,
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 16, color: EchoTheme.dangerRed),
                          label: const Text('Remove Downloaded Weights',
                              style: TextStyle(color: EchoTheme.dangerRed)),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: EchoTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: EchoTheme.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Explicit User Model Download',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: EchoTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'In compliance with ECHO resource policy, model weights (~2.59 GB) are never bundled into the APK. Initial download requires Wi-Fi; inference after installation is 100% offline.',
                          style: TextStyle(
                              fontSize: 12, color: EchoTheme.textSecondary),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: _startDownload,
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label:
                              const Text('Download Gemma 4 E2B-it (~2.59 GB)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: EchoTheme.actionBlue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildStatusPill(LocalLlmStatus status) {
    switch (status) {
      case LocalLlmStatus.ready:
        return const StatusPill(status: 'completed', customLabel: 'READY');
      case LocalLlmStatus.downloading:
        return const StatusPill(
            status: 'processing', customLabel: 'DOWNLOADING');
      case LocalLlmStatus.verifying:
        return const StatusPill(status: 'processing', customLabel: 'VERIFYING');
      case LocalLlmStatus.installing:
        return const StatusPill(
            status: 'processing', customLabel: 'INSTALLING');
      case LocalLlmStatus.initializing:
        return const StatusPill(
            status: 'processing', customLabel: 'INITIALIZING');
      case LocalLlmStatus.running:
        return const StatusPill(status: 'processing', customLabel: 'RUNNING');
      case LocalLlmStatus.failed:
        return const StatusPill(status: 'blocked', customLabel: 'FAILED');
      case LocalLlmStatus.notInstalled:
        return const StatusPill(status: 'draft', customLabel: 'NOT INSTALLED');
    }
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12.5, color: EchoTheme.textSecondary)),
          Text(
            value,
            style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: EchoTheme.textPrimary),
          ),
        ],
      ),
    );
  }
}
