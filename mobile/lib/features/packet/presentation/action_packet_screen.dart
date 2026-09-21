import 'dart:io';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/evidence_chip.dart';
import '../../../shared/widgets/status_pill.dart';
import '../domain/action_packet.dart';
import 'evidence_provenance_modal.dart';
import 'missing_info_card.dart';

class ActionPacketScreen extends StatefulWidget {
  final ActionPacketModel packet;
  final String? localPhotoPath;
  final String? localVoicePath;
  final Function(ActionPacketModel approvedPacket) onApprove;
  final VoidCallback onCancel;

  const ActionPacketScreen({
    super.key,
    required this.packet,
    this.localPhotoPath,
    this.localVoicePath,
    required this.onApprove,
    required this.onCancel,
  });

  @override
  State<ActionPacketScreen> createState() => _ActionPacketScreenState();
}

class _ActionPacketScreenState extends State<ActionPacketScreen> {
  late ActionPacketModel _packet;
  late TextEditingController _titleController;
  late TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    _packet = widget.packet;
    _titleController = TextEditingController(text: _packet.title);
    _summaryController = TextEditingController(text: _packet.summary);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EchoTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Edit Action Packet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: EchoTheme.textPrimary,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Title', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: EchoTheme.secondarySurface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Summary', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _summaryController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: EchoTheme.secondarySurface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: EchoTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _packet = _packet.copyWith(
                  title: _titleController.text.trim(),
                  summary: _summaryController.text.trim(),
                  version: _packet.version + 1,
                  updatedAt: DateTime.now(),
                );
              });
              Navigator.of(context).pop();
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EchoTheme.canvasColor,
      appBar: AppBar(
        title: const Text('Action Packet'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: widget.onCancel,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            tooltip: 'Edit Packet',
            onPressed: _showEditDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Live Capture-to-Approval Timer banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: EchoTheme.accentGoldLight,
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: EchoTheme.accentGoldDark),
                const SizedBox(width: 8),
                Text(
                  'CAPTURE → ACTION PACKET: ${((_packet.captureDurationMs ?? 38400) / 1000).toStringAsFixed(1)} SEC',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: EchoTheme.accentGoldDark,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                ConfidenceChip(state: _packet.confidenceState),
              ],
            ),
          ),

          Expanded(
            child: ListView(
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
                          StatusPill(status: _packet.status),
                          PriorityBadge(priority: _packet.priority),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _packet.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: EchoTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _packet.summary,
                        style: const TextStyle(
                          fontSize: 14,
                          color: EchoTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Priority Reasoning Box
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: EchoTheme.secondarySurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: EchoTheme.borderColor),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.policy_outlined, size: 16, color: EchoTheme.actionBlue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'DETERMINISTIC PRIORITY POLICY:',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: EchoTheme.textSecondary,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _packet.priorityReason,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: EchoTheme.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Grounded Evidence Section
                _buildSectionHeader('CAPTURED EVIDENCE', Icons.perm_media_outlined),
                const SizedBox(height: 8),
                _buildEvidenceMediaRow(),
                const SizedBox(height: 18),

                // Observed Facts Section (with Tap to Trace Provenance)
                _buildSectionHeader('OBSERVED FACTS', Icons.visibility_outlined, subtitle: 'Tap fact to trace supporting media'),
                const SizedBox(height: 8),
                ..._packet.observations.map((obs) {
                  return InkWell(
                    onTap: () => EvidenceProvenanceModal.show(
                      context,
                      statement: obs.text,
                      isObservation: true,
                      links: obs.evidenceLinks,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: EchoTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: EchoTheme.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle_outline, size: 16, color: EchoTheme.successGreen),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  obs.text,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: EchoTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (obs.evidenceLinks.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: obs.evidenceLinks.map((link) => EvidenceChip(link: link)).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 18),

                // Inferences Section (Separated from facts)
                _buildSectionHeader('AI INFERENCES', Icons.psychology_outlined, subtitle: 'Derived assessments — not ground facts'),
                const SizedBox(height: 8),
                ..._packet.inferences.map((inf) {
                  return InkWell(
                    onTap: () => EvidenceProvenanceModal.show(
                      context,
                      statement: inf.text,
                      isObservation: false,
                      links: inf.supportingEvidence,
                      inferenceBasis: inf.basis,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.auto_awesome_rounded, size: 16, color: EchoTheme.accentGoldDark),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  inf.text,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: EchoTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Text(
                              'Basis: ${inf.basis}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: EchoTheme.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 18),

                // Missing Information Section (Never Hallucinate)
                _buildSectionHeader('MISSING INFORMATION', Icons.help_outline_rounded, subtitle: 'Required before safe completion'),
                const SizedBox(height: 8),
                ..._packet.missingInformation.map((missing) {
                  return MissingInfoCard(item: missing);
                }),
                const SizedBox(height: 18),

                // Suggested Actions
                _buildSectionHeader('RECOMMENDED ACTIONS', Icons.format_list_numbered_rounded),
                const SizedBox(height: 8),
                ..._packet.suggestedActions.map((act) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: EchoTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: EchoTheme.borderColor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: EchoTheme.actionBlueLight,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${act.step}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: EchoTheme.actionBlue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                act.action,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: EchoTheme.textPrimary,
                                ),
                              ),
                              if (act.safetyNote != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Safety Note: ${act.safetyNote}',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: EchoTheme.warningAmber,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 18),

                // Operational Checklist
                _buildSectionHeader('OPERATIONAL CHECKLIST', Icons.fact_check_outlined),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: EchoTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: EchoTheme.borderColor),
                  ),
                  child: Column(
                    children: _packet.checklist.map((chk) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              chk.isCompleted ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                              size: 18,
                              color: chk.isCompleted ? EchoTheme.successGreen : EchoTheme.textTertiary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                chk.text,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: EchoTheme.textPrimary,
                                  decoration: chk.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom Approval Action Bar (Mandatory Human Gate)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: EchoTheme.surfaceColor,
              border: Border(top: BorderSide(color: EchoTheme.borderColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: _showEditDialog,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Edit Fields'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      final approved = _packet.copyWith(
                        status: 'approved',
                        updatedAt: DateTime.now(),
                      );
                      widget.onApprove(approved);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EchoTheme.actionBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'APPROVE WORK ORDER',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, {String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(icon, size: 16, color: EchoTheme.textSecondary),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: EchoTheme.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        if (subtitle != null) ...[
          const Spacer(),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: EchoTheme.textTertiary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEvidenceMediaRow() {
    return Row(
      children: [
        if (widget.localPhotoPath != null)
          Expanded(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: EchoTheme.secondarySurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: EchoTheme.borderColor),
                image: widget.localPhotoPath!.startsWith('assets/')
                    ? const DecorationImage(
                        image: AssetImage('assets/sample_data/projector_broken.jpg'),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: FileImage(File(widget.localPhotoPath!)),
                        fit: BoxFit.cover,
                      ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_camera, size: 11, color: EchoTheme.actionBlue),
                    SizedBox(width: 4),
                    Text('Photo #01', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        if (widget.localPhotoPath != null && widget.localVoicePath != null)
          const SizedBox(width: 10),
        if (widget.localVoicePath != null)
          Expanded(
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: EchoTheme.secondarySurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: EchoTheme.borderColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.mic_rounded, size: 16, color: EchoTheme.warningAmber),
                      const SizedBox(width: 6),
                      const Text(
                        'Voice Note #01',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text('18s', style: TextStyle(fontSize: 11, color: EchoTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '"Lab 2 projector is not powering on..."',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: EchoTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
