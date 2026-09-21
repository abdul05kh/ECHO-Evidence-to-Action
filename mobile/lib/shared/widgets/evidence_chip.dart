import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../features/packet/domain/action_packet.dart';

class EvidenceChip extends StatelessWidget {
  final EvidenceLink link;
  final VoidCallback? onTap;
  final bool isHighlighted;

  const EvidenceChip({
    super.key,
    required this.link,
    this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    switch (link.type.toLowerCase()) {
      case 'photo':
        icon = Icons.photo_camera_rounded;
        iconColor = EchoTheme.actionBlue;
        break;
      case 'voice':
        icon = Icons.mic_rounded;
        iconColor = EchoTheme.warningAmber;
        break;
      case 'text':
      default:
        icon = Icons.text_snippet_rounded;
        iconColor = EchoTheme.textSecondary;
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isHighlighted ? EchoTheme.accentGoldLight : EchoTheme.secondarySurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isHighlighted ? EchoTheme.accentGold : EchoTheme.borderColor,
            width: isHighlighted ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 5),
            Text(
              link.label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isHighlighted ? EchoTheme.accentGoldDark : EchoTheme.textPrimary,
              ),
            ),
            if (link.timestampSec != null) ...[
              const SizedBox(width: 4),
              Text(
                '(${link.timestampSec}s)',
                style: const TextStyle(
                  fontSize: 10,
                  color: EchoTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ConfidenceChip extends StatelessWidget {
  final String state; // 'High Confidence', 'Verified', 'Needs Review'

  const ConfidenceChip({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    if (state.toLowerCase().contains('verified') || state.toLowerCase().contains('high')) {
      bg = EchoTheme.successGreenLight;
      fg = EchoTheme.successGreen;
      icon = Icons.verified_user_rounded;
    } else {
      bg = EchoTheme.warningAmberLight;
      fg = EchoTheme.warningAmber;
      icon = Icons.info_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            state,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
