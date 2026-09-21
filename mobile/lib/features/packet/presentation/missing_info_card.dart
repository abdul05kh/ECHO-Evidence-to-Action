import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../domain/action_packet.dart';

class MissingInfoCard extends StatelessWidget {
  final MissingInfoItem item;
  final ValueChanged<String>? onResolve;

  const MissingInfoCard({
    super.key,
    required this.item,
    this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isResolved ? EchoTheme.successGreenLight.withOpacity(0.5) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isResolved ? EchoTheme.successGreen.withOpacity(0.4) : EchoTheme.warningAmber.withOpacity(0.5),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                item.isResolved ? Icons.check_circle_rounded : Icons.help_outline_rounded,
                size: 18,
                color: item.isResolved ? EchoTheme.successGreen : EchoTheme.warningAmber,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.prompt,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: EchoTheme.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Text(
              item.contextReason,
              style: const TextStyle(
                fontSize: 12.5,
                color: EchoTheme.textSecondary,
                height: 1.3,
              ),
            ),
          ),
          if (item.suggestedCheck != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: EchoTheme.borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app_outlined, size: 13, color: EchoTheme.actionBlue),
                    const SizedBox(width: 6),
                    Text(
                      'Suggested: ${item.suggestedCheck}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: EchoTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (item.isResolved && item.resolutionText != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: Text(
                'Resolution: ${item.resolutionText}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: EchoTheme.successGreen,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
