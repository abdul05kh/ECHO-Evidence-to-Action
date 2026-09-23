import 'dart:io';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/category_chip.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../bridge/office_kit_bridge.dart';
import '../../capture/presentation/camera_screen.dart';
import '../../packet/domain/action_packet.dart';
import '../domain/task_state_machine.dart';

class TaskDetailScreen extends StatefulWidget {
  final ActionPacketModel packet;
  final String? initialPhotoPath;
  final String? initialVoicePath;
  final Function(ActionPacketModel updatedPacket) onTaskUpdated;

  const TaskDetailScreen({
    super.key,
    required this.packet,
    this.initialPhotoPath,
    this.initialVoicePath,
    required this.onTaskUpdated,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late ActionPacketModel _packet;
  String _currentStatus = 'approved';
  String? _assignedTo;
  String? _closurePhotoPath;
  final TextEditingController _completionNoteController =
      TextEditingController();
  final List<Map<String, dynamic>> _auditEvents = [];

  final List<String> _assigneeOptions = [
    'Aisha K. (Field Tech)',
    'Marcus V. (AV Specialist)',
    'Devon L. (Campus Dispatch)',
    'Unassigned',
  ];

  @override
  void initState() {
    super.initState();
    _packet = widget.packet;
    _currentStatus = _packet.status;

    // Record initial approval event
    _auditEvents.add({
      'event': 'TASK_APPROVED',
      'actor': 'Human Operator',
      'timestamp': _packet.createdAt,
      'details': 'Approved Action Packet and initialized work order.',
    });
  }

  @override
  void dispose() {
    _completionNoteController.dispose();
    super.dispose();
  }

  Future<void> _transitionTo(String targetStatus,
      {String? reason, bool confirm = false}) async {
    if (!TaskStateMachine.canTransition(_currentStatus, targetStatus)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Cannot transition from $_currentStatus to $targetStatus'),
          backgroundColor: EchoTheme.dangerRed,
        ),
      );
      return;
    }

    if (confirm) {
      final confirmed = await ConfirmDialog.show(
        context,
        title: 'Confirm State Transition',
        message:
            'Are you sure you want to transition task status to "${targetStatus.toUpperCase()}"?',
        confirmLabel: 'Transition',
      );
      if (!confirmed) return;
    }

    setState(() {
      _currentStatus = targetStatus;
      _packet = _packet.copyWith(
        status: targetStatus,
        updatedAt: DateTime.now(),
      );

      _auditEvents.insert(0, {
        'event': 'STATUS_${targetStatus.toUpperCase()}',
        'actor': 'Operator / Supervisor',
        'timestamp': DateTime.now(),
        'details':
            reason ?? 'Transitioned state to ${targetStatus.toUpperCase()}',
      });
    });

    widget.onTaskUpdated(_packet);
  }

  void _toggleChecklistItem(int index) {
    setState(() {
      final updatedList = List<ChecklistItemData>.from(_packet.checklist);
      final current = updatedList[index];
      updatedList[index] = current.copyWith(isCompleted: !current.isCompleted);

      _packet =
          _packet.copyWith(checklist: updatedList, updatedAt: DateTime.now());

      _auditEvents.insert(0, {
        'event': 'CHECKLIST_ITEM_UPDATED',
        'actor': 'Field Operator',
        'timestamp': DateTime.now(),
        'details':
            '${updatedList[index].isCompleted ? "Completed" : "Unchecked"}: "${current.text}"',
      });
    });

    widget.onTaskUpdated(_packet);
  }

  void _captureClosurePhoto() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          onPhotoCaptured: (path) {
            setState(() {
              _closurePhotoPath = path;
            });
          },
        ),
      ),
    );
  }

  Future<void> _completeTaskWithEvidence() async {
    if (_closurePhotoPath == null &&
        _completionNoteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please capture an after-photo or enter a completion note for closure verification.'),
          backgroundColor: EchoTheme.warningAmber,
        ),
      );
      return;
    }

    await _transitionTo(
      'completed',
      reason:
          'Work completed with closure evidence. Note: "${_completionNoteController.text.trim()}"',
      confirm: true,
    );
  }

  Future<void> _exportToOfficeKit() async {
    final result = await OfficeKitBridge.copyToClipboard(_packet);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.success
              ? 'Handoff payload copied to clipboard (.echopack.json)'
              : 'Export failed: ${result.message}',
        ),
        backgroundColor:
            result.success ? EchoTheme.successGreen : EchoTheme.dangerRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedChecklistCount =
        _packet.checklist.where((c) => c.isCompleted).length;

    return Scaffold(
      backgroundColor: EchoTheme.canvasColor,
      appBar: AppBar(
        title: Text(_packet.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.devices_rounded),
            tooltip: 'Export via Office Kit',
            onPressed: _exportToOfficeKit,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status & Priority Card
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
                  children: [
                    StatusPill(status: _currentStatus, isLarge: true),
                    const SizedBox(width: 8),
                    CategoryChip(category: _packet.category, fontSize: 11),
                    const Spacer(),
                    PriorityBadge(priority: _packet.priority),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _packet.title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: EchoTheme.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  _packet.summary,
                  style: const TextStyle(
                      fontSize: 13.5,
                      color: EchoTheme.textSecondary,
                      height: 1.4),
                ),
                const SizedBox(height: 14),

                // Assignee Selector
                Row(
                  children: [
                    const Text('Assignee: ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _assignedTo ?? 'Unassigned',
                      underline: const SizedBox(),
                      items: _assigneeOptions
                          .map((opt) => DropdownMenuItem(
                              value: opt,
                              child: Text(opt,
                                  style: const TextStyle(fontSize: 13))))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _assignedTo = val;
                          _auditEvents.insert(0, {
                            'event': 'ASSIGNEE_UPDATED',
                            'actor': 'Supervisor',
                            'timestamp': DateTime.now(),
                            'details': 'Assigned task to $val',
                          });
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Checklist Section
          if (_packet.checklist.isNotEmpty)
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
                        'OPERATIONAL CHECKLIST',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: EchoTheme.textSecondary,
                            letterSpacing: 0.5),
                      ),
                      Text(
                        '$completedChecklistCount of ${_packet.checklist.length} completed',
                        style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: EchoTheme.textTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._packet.checklist.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    return InkWell(
                      onTap: () => _toggleChecklistItem(idx),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isCompleted,
                              activeColor: EchoTheme.successGreen,
                              onChanged: (_) => _toggleChecklistItem(idx),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.text,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: item.isCompleted
                                      ? EchoTheme.textTertiary
                                      : EchoTheme.textPrimary,
                                  decoration: item.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Closure Evidence & Complete Action Section
          _buildEvidenceComparisonSection(),
          const SizedBox(height: 16),

          // Audit Trail Section
          _buildAuditTrailSection(),
        ],
      ),
    );
  }

  Widget _buildEvidenceComparisonSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EchoTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EchoTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('EVIDENCE COMPARISON (BEFORE & AFTER)',
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: EchoTheme.textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              // Before Photo (Initial Evidence)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('BEFORE (Incident)',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: EchoTheme.textTertiary)),
                    const SizedBox(height: 6),
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: EchoTheme.secondarySurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: EchoTheme.borderColor),
                      ),
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image_outlined,
                              size: 28, color: EchoTheme.textSecondary),
                          SizedBox(height: 4),
                          Text('Incident Photo #01',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // After Photo (Closure Evidence)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AFTER (Closure)',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: EchoTheme.successGreen)),
                    const SizedBox(height: 6),
                    if (_closurePhotoPath != null)
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: EchoTheme.secondarySurface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: EchoTheme.successGreen, width: 1.5),
                          image: DecorationImage(
                            image: FileImage(File(_closurePhotoPath!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      InkWell(
                        onTap: _captureClosurePhoto,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: EchoTheme.secondarySurface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: EchoTheme.borderColor,
                                style: BorderStyle.solid),
                          ),
                          alignment: Alignment.center,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined,
                                  size: 24, color: EchoTheme.actionBlue),
                              SizedBox(height: 4),
                              Text('Capture After-Photo',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: EchoTheme.actionBlue)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (_currentStatus != 'completed') ...[
            const SizedBox(height: 14),
            TextField(
              controller: _completionNoteController,
              decoration: InputDecoration(
                hintText:
                    'Add completion note (e.g. Swapped power cable from Room B; display tested)...',
                hintStyle: const TextStyle(
                    fontSize: 12, color: EchoTheme.textTertiary),
                filled: true,
                fillColor: EchoTheme.secondarySurface,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _completeTaskWithEvidence,
                icon: const Icon(Icons.verified_rounded, size: 16),
                label: const Text('COMPLETE WORK ORDER WITH CLOSURE EVIDENCE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: EchoTheme.successGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAuditTrailSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EchoTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EchoTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('IMMUTABLE AUDIT TRAIL',
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: EchoTheme.textSecondary)),
          const SizedBox(height: 10),
          ..._auditEvents.map((evt) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: EchoTheme.actionBlue, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(evt['event'],
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: EchoTheme.textPrimary)),
                            Text(
                              '${(evt['timestamp'] as DateTime).hour.toString().padLeft(2, '0')}:${(evt['timestamp'] as DateTime).minute.toString().padLeft(2, '0')}:${(evt['timestamp'] as DateTime).second.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  fontSize: 10.5,
                                  color: EchoTheme.textTertiary),
                            ),
                          ],
                        ),
                        Text(evt['details'],
                            style: const TextStyle(
                                fontSize: 12, color: EchoTheme.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
