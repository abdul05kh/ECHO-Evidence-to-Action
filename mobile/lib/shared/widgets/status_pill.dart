import 'package:flutter/material.dart';
import '../../app/theme.dart';

class StatusPill extends StatelessWidget {
  final String status;
  final bool isLarge;

  const StatusPill({
    super.key,
    required this.status,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status.toLowerCase()) {
      case 'draft':
        bg = EchoTheme.secondarySurface;
        fg = EchoTheme.textSecondary;
        label = 'DRAFT';
        break;
      case 'processing':
        bg = EchoTheme.actionBlueLight;
        fg = EchoTheme.actionBlue;
        label = 'PROCESSING';
        break;
      case 'needs_review':
        bg = EchoTheme.warningAmberLight;
        fg = EchoTheme.warningAmber;
        label = 'NEEDS REVIEW';
        break;
      case 'ready':
        bg = EchoTheme.accentGoldLight;
        fg = EchoTheme.accentGoldDark;
        label = 'READY FOR APPROVAL';
        break;
      case 'approved':
        bg = EchoTheme.successGreenLight;
        fg = EchoTheme.successGreen;
        label = 'APPROVED';
        break;
      case 'assigned':
        bg = EchoTheme.actionBlueLight;
        fg = EchoTheme.actionBlue;
        label = 'ASSIGNED';
        break;
      case 'in_progress':
        bg = const Color(0xFFE0E7FF);
        fg = const Color(0xFF4338CA);
        label = 'IN PROGRESS';
        break;
      case 'blocked':
        bg = EchoTheme.dangerRedLight;
        fg = EchoTheme.dangerRed;
        label = 'BLOCKED';
        break;
      case 'completed':
        bg = EchoTheme.successGreenLight;
        fg = EchoTheme.successGreen;
        label = 'COMPLETED';
        break;
      case 'reopened':
        bg = EchoTheme.warningAmberLight;
        fg = EchoTheme.warningAmber;
        label = 'REOPENED';
        break;
      default:
        bg = EchoTheme.secondarySurface;
        fg = EchoTheme.textSecondary;
        label = status.toUpperCase();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 12 : 8,
        vertical: isLarge ? 6 : 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: isLarge ? 12 : 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class PriorityBadge extends StatelessWidget {
  final String priority;
  final bool showIcon;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (priority.toLowerCase()) {
      case 'critical':
        bg = EchoTheme.dangerRedLight;
        fg = EchoTheme.dangerRed;
        icon = Icons.error_rounded;
        label = 'CRITICAL';
        break;
      case 'high':
        bg = EchoTheme.warningAmberLight;
        fg = EchoTheme.warningAmber;
        icon = Icons.priority_high_rounded;
        label = 'HIGH PRIORITY';
        break;
      case 'medium':
        bg = const Color(0xFFEFF6FF);
        fg = EchoTheme.actionBlue;
        icon = Icons.tune_rounded;
        label = 'MEDIUM';
        break;
      case 'low':
      default:
        bg = EchoTheme.secondarySurface;
        fg = EchoTheme.textSecondary;
        icon = Icons.arrow_downward_rounded;
        label = 'LOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
