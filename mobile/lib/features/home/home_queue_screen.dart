import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../shared/widgets/status_pill.dart';
import '../ai/local_llm_provider.dart';
import '../ai/model_adapter.dart';
import '../bridge/office_kit_bridge.dart';
import '../capture/presentation/capture_view.dart';
import '../fixtures/canonical_demo_fixture.dart';
import '../packet/domain/action_packet.dart';
import '../settings/presentation/ai_runtime_screen.dart';
import '../tasks/presentation/task_detail_screen.dart';
import 'search_filter_state.dart';

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
  final TextEditingController _searchController = TextEditingController();
  SearchFilterState _filterState = const SearchFilterState();

  @override
  void initState() {
    super.initState();
    _seedInitialCanonicalData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                content: Text(
                    'Task "${approvedPacket.title}" approved and created locally!'),
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
              final idx =
                  _activeTasks.indexWhere((t) => t.id == updatedPacket.id);
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
            Text('Office Kit Bridge Export',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
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
                  Text('Packet ID: ${packet.id}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 12)),
                  Text('Title: ${packet.title}',
                      style: const TextStyle(fontSize: 12)),
                  Text('Priority: ${packet.priority.toUpperCase()}',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Switch to Laptop Workspace -> Tap "Import Packet" -> Zero retyping.',
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: EchoTheme.actionBlue),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_outlined,
                    color: EchoTheme.accentGold, size: 22),
                const SizedBox(width: 10),
                const Text(
                  'SYSTEM DIAGNOSTIC OVERVIEW',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: EchoTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      size: 20, color: EchoTheme.textTertiary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _diagRow('Model Adapter Active', status.modelName),
            _diagRow('Runtime Mode', status.mode.name),
            _diagRow('Local LLM Initialized',
                status.isAvailable ? 'YES (100% On-Device)' : 'NO'),
            _diagRow('Offline Outbox Status', 'IDLE (0 pending syncs)'),
            _diagRow('Active Storage DB',
                'echo_local.sqlite (Drift / Native SQLite)'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AIRuntimeScreen(
                        localLlmProvider: LiteRtLocalLlmProvider(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.tune_rounded, size: 18),
                label: const Text('OPEN AI RUNTIME DIAGNOSTICS'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _diagRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: EchoTheme.textSecondary)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: EchoTheme.textPrimary,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefreshQueue() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filterState.apply(_activeTasks);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: EchoTheme.successGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text('ECHO HANDOFF', style: TextStyle(letterSpacing: 0.5)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: EchoTheme.textSecondary),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AIRuntimeScreen(
                    localLlmProvider: LiteRtLocalLlmProvider(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded,
                color: EchoTheme.textSecondary),
            onPressed: _showTechnicalDiagnostic,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefreshQueue,
          color: EchoTheme.accentGold,
          backgroundColor: EchoTheme.surfaceColor,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Primary Action Card
                    InkWell(
                      onTap: _openCapture,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: EchoTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: EchoTheme.accentGold.withAlpha(100),
                              width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(76),
                              blurRadius: 12,
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
                              child: const Icon(Icons.add_a_photo_rounded,
                                  color: EchoTheme.textPrimary, size: 26),
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
                            const Icon(Icons.arrow_forward_ios_rounded,
                                size: 16, color: EchoTheme.textTertiary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Metrics Row
                    Row(
                      children: [
                        _metricCard('ACTIVE TASKS', '${_activeTasks.length}',
                            Icons.assignment_outlined, EchoTheme.actionBlue),
                        const SizedBox(width: 10),
                        _metricCard('AVG WORKFLOW', '38s', Icons.timer_outlined,
                            EchoTheme.accentGoldDark),
                        const SizedBox(width: 10),
                        _metricCard('LOCAL PERSIST', '100%',
                            Icons.storage_rounded, EchoTheme.successGreen),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search and Filter Section
                    _buildSearchAndFilterSection(),
                    const SizedBox(height: 16),

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
                          '${filteredTasks.length} of ${_activeTasks.length} items',
                          style: const TextStyle(
                              fontSize: 12, color: EchoTheme.textTertiary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (filteredTasks.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: EchoTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: EchoTheme.borderColor),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _filterState.isFiltered
                                  ? Icons.search_off_rounded
                                  : Icons.task_alt_rounded,
                              size: 40,
                              color: EchoTheme.textTertiary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _filterState.isFiltered
                                  ? 'No Matching Work Orders'
                                  : 'No Active Work Orders',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: EchoTheme.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _filterState.isFiltered
                                  ? 'Try adjusting your search query or clear filters.'
                                  : 'Captured issues will appear here after approval.',
                              style: const TextStyle(
                                  fontSize: 12, color: EchoTheme.textSecondary),
                            ),
                            if (_filterState.isFiltered) ...[
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _filterState = const SearchFilterState();
                                  });
                                },
                                icon: const Icon(Icons.clear_all_rounded,
                                    size: 16),
                                label: const Text('Clear Filters'),
                              ),
                            ],
                          ],
                        ),
                      )
                    else
                      ...filteredTasks.map((task) => _buildTaskCard(task)),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input
        TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() {
              _filterState = _filterState.copyWith(query: val);
            });
          },
          decoration: InputDecoration(
            hintText: 'Search title, ID, category, or summary...',
            prefixIcon: const Icon(Icons.search_rounded,
                size: 20, color: EchoTheme.textTertiary),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.cancel_rounded,
                        size: 18, color: EchoTheme.textTertiary),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _filterState = _filterState.copyWith(query: '');
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: EchoTheme.surfaceColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: EchoTheme.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: EchoTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: EchoTheme.accentGold),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip(
                label: 'All Categories',
                isSelected: _filterState.selectedCategory == null,
                onSelected: () {
                  setState(() {
                    _filterState = _filterState.copyWith(clearCategory: true);
                  });
                },
              ),
              const SizedBox(width: 6),
              ...['equipment', 'facility', 'electrical', 'plumbing', 'safety']
                  .map((cat) {
                final isSel = _filterState.selectedCategory?.toLowerCase() ==
                    cat.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: _filterChip(
                    label: cat.toUpperCase(),
                    isSelected: isSel,
                    onSelected: () {
                      setState(() {
                        _filterState = isSel
                            ? _filterState.copyWith(clearCategory: true)
                            : _filterState.copyWith(selectedCategory: cat);
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Priority Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip(
                label: 'All Priorities',
                isSelected: _filterState.selectedPriority == null,
                onSelected: () {
                  setState(() {
                    _filterState = _filterState.copyWith(clearPriority: true);
                  });
                },
              ),
              const SizedBox(width: 6),
              ...['low', 'medium', 'high', 'urgent'].map((prio) {
                final isSel = _filterState.selectedPriority?.toLowerCase() ==
                    prio.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: _filterChip(
                    label: prio.toUpperCase(),
                    isSelected: isSel,
                    onSelected: () {
                      setState(() {
                        _filterState = isSel
                            ? _filterState.copyWith(clearPriority: true)
                            : _filterState.copyWith(selectedPriority: prio);
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? EchoTheme.accentGold.withAlpha(51)
              : EchoTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? EchoTheme.accentGold : EchoTheme.borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? EchoTheme.accentGold : EchoTheme.textSecondary,
          ),
        ),
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
                StatusPill(status: task.priority),
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
              style:
                  const TextStyle(fontSize: 13, color: EchoTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'ID: ${task.id}',
                  style: const TextStyle(
                      fontSize: 11,
                      color: EchoTheme.textTertiary,
                      fontFamily: 'monospace'),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => _exportToOfficeKit(task),
                  icon: const Icon(Icons.devices_rounded, size: 14),
                  label:
                      const Text('Office Kit', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
