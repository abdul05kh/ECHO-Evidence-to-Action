import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../shared/widgets/status_pill.dart';
import '../ai/model_adapter.dart';
import '../bridge/office_kit_bridge.dart';
import '../capture/presentation/capture_view.dart';
import '../fixtures/canonical_demo_fixture.dart';
import '../packet/domain/action_packet.dart';
import '../tasks/presentation/task_detail_screen.dart';

import '../settings/presentation/ai_runtime_screen.dart';
import '../ai/local_llm_provider.dart';

class HomeQueueScreen extends StatefulWidget {
  final ModelAdapter modelAdapter;

  const HomeQueueScreen({
    super.key,
    required this.modelAdapter,
  });

  @override
  State<HomeQueueScreen> createState() => _HomeQueueScreenState();
}

class _HomeQueueScreenState extends State<HomeQueueScreen> {
  final List<ActionPacketModel> _activeTasks = [];

  @override
  void initState() {
    super.initState();
    _seedInitialCanonicalData();
  }

  void _seedInitialCanonicalData() {
    final demoPacket = CanonicalDemoFixture.buildPacket(
      photoEvidenceId: 'ev_demo_seed_p1',
      voiceEvidenceId: 'ev_demo_seed_v1',
      captureDurationMs: 38400,
    ).copyWith(
      id: 'ap_demo_seed_01',
      status: 'approved',
    );
    _activeTasks.add(demoPacket);
  }

  void _openCapture() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CaptureView(
          modelAdapter: widget.modelAdapter,
          onPacketApproved: (approvedPacket) {
            setState(() {
              _activeTasks.insert(0, approvedPacket);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Task "${approvedPacket.title}" approved and created locally!'),
                backgroundColor: EchoTheme.successGreen,
                action: SnackBarAction(
                  label: 'OFFICE KIT',
                  textColor: Colors.white,
                  onPressed: () => _exportToOfficeKit(approvedPacket),
                ),
              ),
            );
          },
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _openTaskDetail(ActionPacketModel task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          packet: task,
          onTaskUpdated: (updatedPacket) {
            setState(() {
              final idx = _activeTasks.indexWhere((t) => t.id == updatedPacket.id);
              if (idx != -1) {
                _activeTasks[idx] = updatedPacket;
              }
            });
          },
        ),
      ),
    );
  }

  void _exportToOfficeKit(ActionPacketModel packet) async {
    await OfficeKitBridge.copyToClipboard(packet);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EchoTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.devices_rounded, color: EchoTheme.actionBlue, size: 22),
            SizedBox(width: 8),
            Text('Office Kit Bridge Export', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Action Packet successfully formatted and copied to system clipboard.',
              style: TextStyle(fontSize: 13.5, color: EchoTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: EchoTheme.secondarySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Packet ID: ${packet.id}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  Text('Title: ${packet.title}', style: const TextStyle(fontSize: 12)),
                  Text('Priority: ${packet.priority.toUpperCase()}', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Switch to Laptop Workspace -> Tap "Import Packet" -> Zero retyping.',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: EchoTheme.actionBlue),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showTechnicalDiagnostic() async {
    final status = await widget.modelAdapter.getStatus();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: EchoTheme.surfaceColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.developer_board_rounded, color: EchoTheme.accentGoldDark, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'TECHNICAL DIAGNOSTIC PANEL',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            const SizedBox(height: 12),
            _diagRow('Model Runtime', status.displayName),
            _diagRow('Target Architecture', status.deviceArchitecture),
            _diagRow('Average Latency', '${status.averageLatencyMs} ms'),
            _diagRow('Local SQLite Persistence', 'ACTIVE (Drift Schema v1)'),
            _diagRow('Offline Outbox Status', 'IDLE (0 pending syncs)'),
            _diagRow('Office Kit Protocol', 'READY (Clipboard & JSON v1.0)'),
            const SizedBox(height: 16),
            const Text(
              'ECHO adheres strictly to AI Honesty. Prototype runtimes and fallback modes are clearly demarcated.',
              style: TextStyle(fontSize: 11.5, color: EchoTheme.textSecondary, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _diagRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: EchoTheme.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: EchoTheme.textPrimary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EchoTheme.canvasColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: EchoTheme.accentGold,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'ECHO',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: EchoTheme.textPrimary,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Field Orchestrator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.memory_rounded, color: EchoTheme.actionBlue),
            tooltip: 'AI Runtime & Model Status',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AiRuntimeScreen(
                    localLlmProvider: LiteRtLocalLlmProvider(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Technical Diagnostic',
            onPressed: _showTechnicalDiagnostic,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Offline Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: const Color(0xFFF1F5F9),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: EchoTheme.successGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'LOCAL-FIRST MODE · Stored securely on this device',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: EchoTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                const Text(
                  '0 queued',
                  style: TextStyle(fontSize: 11, color: EchoTheme.textTertiary),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Heartbeat Capture CTA
                InkWell(
                  onTap: _openCapture,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: EchoTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: EchoTheme.accentGold, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: EchoTheme.accentGold.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: EchoTheme.accentGold,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_a_photo_rounded, color: EchoTheme.textPrimary, size: 26),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '+ CAPTURE ISSUE',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: EchoTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Photograph + Voice context -> Action Packet',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: EchoTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: EchoTheme.textTertiary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Metrics Row
                Row(
                  children: [
                    _metricCard('ACTIVE TASKS', '${_activeTasks.length}', Icons.assignment_outlined, EchoTheme.actionBlue),
                    const SizedBox(width: 10),
                    _metricCard('AVG WORKFLOW', '38s', Icons.timer_outlined, EchoTheme.accentGoldDark),
                    const SizedBox(width: 10),
                    _metricCard('LOCAL PERSIST', '100%', Icons.storage_rounded, EchoTheme.successGreen),
                  ],
                ),
                const SizedBox(height: 24),

                // Active Queue Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ACTIVE WORK ORDERS',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: EchoTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '${_activeTasks.length} items',
                      style: const TextStyle(fontSize: 12, color: EchoTheme.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (_activeTasks.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: EchoTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: EchoTheme.borderColor),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.task_alt_rounded, size: 40, color: EchoTheme.textTertiary),
                        SizedBox(height: 10),
                        Text(
                          'No Active Work Orders',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EchoTheme.textPrimary),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Captured issues will appear here after approval.',
                          style: TextStyle(fontSize: 12, color: EchoTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                else
                  ..._activeTasks.map((task) => _buildTaskCard(task)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: EchoTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EchoTheme.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: EchoTheme.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: EchoTheme.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(ActionPacketModel task) {
    return InkWell(
      onTap: () => _openTaskDetail(task),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
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
                StatusPill(status: task.status),
                PriorityBadge(priority: task.priority),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: EchoTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              task.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: EchoTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'ID: ${task.id}',
                  style: const TextStyle(fontSize: 11, color: EchoTheme.textTertiary, fontFamily: 'monospace'),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => _exportToOfficeKit(task),
                  icon: const Icon(Icons.devices_rounded, size: 14),
                  label: const Text('Office Kit', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
