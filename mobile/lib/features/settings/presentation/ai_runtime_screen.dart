import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../ai/local_llm_provider.dart';

class AiRuntimeScreen extends StatefulWidget {
  final LocalLlmProvider localLlmProvider;

  const AiRuntimeScreen({
    super.key,
    required this.localLlmProvider,
  });

  @override
  State<AiRuntimeScreen> createState() => _AiRuntimeScreenState();
}

class _AiRuntimeScreenState extends State<AiRuntimeScreen> {
  LocalLlmRuntimeInfo? _info;
  bool _isLoading = true;
  StreamSubscription<double>? _downloadSub;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadRuntimeInfo();
  }

  @override
  void dispose() {
    _downloadSub?.cancel();
    super.dispose();
  }

  Future<void> _loadRuntimeInfo() async {
    setState(() => _isLoading = true);
    final info = await widget.localLlmProvider.runtimeInfo();
    if (mounted) {
      setState(() {
        _info = info;
        _isLoading = false;
        _progress = info.downloadProgress;
      });
    }
  }

  void _startDownload() {
    _downloadSub?.cancel();
    setState(() {
      _progress = 0.0;
    });
    _downloadSub = widget.localLlmProvider.downloadModel().listen(
      (prog) {
        if (mounted) {
          setState(() {
            _progress = prog;
          });
        }
      },
      onDone: () {
        _loadRuntimeInfo();
      },
    );
  }

  void _cancelDownload() {
    widget.localLlmProvider.cancelDownload();
    _downloadSub?.cancel();
    _loadRuntimeInfo();
  }

  Future<void> _deleteModel() async {
    await widget.localLlmProvider.deleteModel();
    _loadRuntimeInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EchoTheme.canvasColor,
      appBar: AppBar(
        title: const Text('AI Runtime & Edge LLM'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header Card
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
                            'ON-DEVICE LLM STATUS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: EchoTheme.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          _buildStatusPill(_info?.status ?? LocalLlmStatus.notInstalled),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _info?.modelName ?? 'Gemma 4 E2B-it (LiteRT-LM)',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: EchoTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Version: ${_info?.version ?? "v1.0.0-int4-quantized"} · ARM64 Qualcomm GPU',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: EchoTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Specs Grid Card
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
                        'TECHNICAL RUNTIME METRICS',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: EchoTheme.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildSpecRow('Target Model', _info?.modelName ?? 'Gemma 4 E2B-it (LiteRT-LM)'),
                      _buildSpecRow('Model Size', _info?.formattedModelSize ?? '2.59 GB'),
                      _buildSpecRow('Storage Required', _info?.formattedRequiredStorage ?? '3.20 GB'),
                      _buildSpecRow(
                        _info?.activeBackend != null ? 'Active Backend' : 'Target Backend',
                        _info?.activeBackend ?? _info?.targetBackend ?? 'LiteRT-LM (OpenCL GPU)',
                      ),
                      _buildSpecRow(
                        'Model Load Time',
                        _info?.modelLoadLatencyMs != null ? '${_info!.modelLoadLatencyMs} ms' : 'Not measured',
                      ),
                      _buildSpecRow(
                        'First Token Latency',
                        _info?.firstTokenLatencyMs != null ? '${_info!.firstTokenLatencyMs} ms' : 'Not measured',
                      ),
                      _buildSpecRow(
                        'Total Generation',
                        _info?.totalGenerationLatencyMs != null ? '${_info!.totalGenerationLatencyMs} ms' : 'Not measured',
                      ),
                      _buildSpecRow(
                        'Average Latency',
                        _info?.averageLatencyMs != null ? '${_info!.averageLatencyMs} ms' : 'Not measured',
                      ),
                      _buildSpecRow('Device Architecture', _info?.isArm64 == true ? 'ARM64 (Qualcomm Snapdragon)' : 'Generic ARM'),
                      _buildSpecRow('Available System RAM', '${_info?.availableRamMb ?? 11200} MB / 12 GB (Min: 8 GB)'),
                      _buildSpecRow(
                        'Initial Download',
                        'Wi-Fi required (~2.59 GB)',
                      ),
                      _buildSpecRow(
                        'Inference Requirement',
                        'Offline (0 KB network required)',
                      ),
                      _buildSpecRow(
                        'Last Error',
                        _info?.lastError ?? 'None',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Download / Action Card
                if (_info?.status == LocalLlmStatus.downloading || _info?.status == LocalLlmStatus.installing) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: EchoTheme.actionBlueLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: EchoTheme.actionBlue.withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: EchoTheme.actionBlue),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _info?.status == LocalLlmStatus.installing
                                  ? 'Installing & Initializing Weights...'
                                  : 'Downloading Model Weights... ${(_progress * 100).toInt()}%',
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
                          value: _progress,
                          backgroundColor: Colors.white,
                          color: EchoTheme.actionBlue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${((_progress * 2.59)).toStringAsFixed(2)} GB of 2.59 GB downloaded to app-private storage...',
                          style: const TextStyle(fontSize: 11.5, color: EchoTheme.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _cancelDownload,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: EchoTheme.dangerRed),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: const Text('Cancel Download', style: TextStyle(color: EchoTheme.dangerRed, fontSize: 12)),
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
                      border: Border.all(color: EchoTheme.successGreen.withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: EchoTheme.successGreen, size: 18),
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
                          style: TextStyle(fontSize: 12, color: EchoTheme.textPrimary),
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: _deleteModel,
                          icon: const Icon(Icons.delete_outline_rounded, size: 16, color: EchoTheme.dangerRed),
                          label: const Text('Remove Downloaded Weights', style: TextStyle(color: EchoTheme.dangerRed)),
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
                          style: TextStyle(fontSize: 12, color: EchoTheme.textSecondary),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: _startDownload,
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: const Text('Download Gemma 4 E2B-it (~2.59 GB)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: EchoTheme.actionBlue,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        return const StatusPill(status: 'processing', customLabel: 'DOWNLOADING');
      case LocalLlmStatus.installing:
        return const StatusPill(status: 'processing', customLabel: 'INSTALLING');
      case LocalLlmStatus.initializing:
        return const StatusPill(status: 'processing', customLabel: 'INITIALIZING');
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
          Text(label, style: const TextStyle(fontSize: 12.5, color: EchoTheme.textSecondary)),
          Text(
            value,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: EchoTheme.textPrimary),
          ),
        ],
      ),
    );
  }
}
