import 'dart:io';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../domain/action_packet.dart';

class EvidenceProvenanceModal extends StatelessWidget {
  final String statement;
  final bool isObservation; // true = observed fact, false = inference
  final List<EvidenceLink> links;
  final String? inferenceBasis;

  const EvidenceProvenanceModal({
    super.key,
    required this.statement,
    required this.isObservation,
    required this.links,
    this.inferenceBasis,
  });

  static void show(
    BuildContext context, {
    required String statement,
    required bool isObservation,
    required List<EvidenceLink> links,
    String? inferenceBasis,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => EvidenceProvenanceModal(
        statement: statement,
        isObservation: isObservation,
        links: links,
        inferenceBasis: inferenceBasis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: EchoTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: EchoTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Icon(
                isObservation ? Icons.visibility_rounded : Icons.psychology_rounded,
                color: isObservation ? EchoTheme.actionBlue : EchoTheme.accentGoldDark,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isObservation ? 'EVIDENCE PROVENANCE' : 'INFERENCE REASONING',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isObservation ? EchoTheme.actionBlue : EchoTheme.accentGoldDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Statement box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EchoTheme.secondarySurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: EchoTheme.borderColor),
            ),
            child: Text(
              '"$statement"',
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: EchoTheme.textPrimary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (!isObservation && inferenceBasis != null) ...[
            const Text(
              'REASONING BASIS:',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: EchoTheme.textSecondary,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              inferenceBasis!,
              style: const TextStyle(
                fontSize: 13,
                color: EchoTheme.textPrimary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
          ],

          const Text(
            'SUPPORTING EVIDENCE CITATIONS:',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: EchoTheme.textSecondary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),

          if (links.isEmpty)
            const Text(
              'No direct media clips cited for this statement.',
              style: TextStyle(fontSize: 13, color: EchoTheme.textSecondary),
            )
          else
            ...links.map((link) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: EchoTheme.borderColor),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      link.type == 'photo'
                          ? Icons.photo_camera_rounded
                          : (link.type == 'voice' ? Icons.mic_rounded : Icons.description_rounded),
                      size: 18,
                      color: EchoTheme.actionBlue,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                link.label,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: EchoTheme.textPrimary,
                                ),
                              ),
                              if (link.timestampSec != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: EchoTheme.secondarySurface,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '@ 00:${link.timestampSec!.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: EchoTheme.textSecondary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (link.excerpt != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Excerpt: "${link.excerpt}"',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: EchoTheme.textSecondary,
                                fontStyle: FontStyle.italic,
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

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close Provenance View'),
            ),
          ),
        ],
      ),
    );
  }
}
