import 'package:flutter/material.dart';
import '../../app/theme.dart';
export 'priority_badge.dart';

class StatusPill extends StatelessWidget {
  final String status;
  final String? customLabel;
  final bool isLarge;

  const StatusPill({
    super.key,
    required this.status,
    this.customLabel,
    this.isLarge = false,
  });

  static ({Color bg, Color fg}) colorsForStatus(String status) {
    switch (status.toLowerCase().trim()) {
      case 'draft':
        return (bg: EchoTheme.secondarySurface, fg: EchoTheme.textSecondary);
      case 'processing':
        return (bg: EchoTheme.actionBlueLight, fg: EchoTheme.actionBlue);
      case 'needs_review':
        return (bg: EchoTheme.warningAmberLight, fg: EchoTheme.warningAmber);
      case 'ready':
        return (bg: EchoTheme.accentGoldLight, fg: EchoTheme.accentGoldDark);
      case 'approved':
        return (bg: EchoTheme.successGreenLight, fg: EchoTheme.successGreen);
      case 'assigned':
        return (bg: EchoTheme.actionBlueLight, fg: EchoTheme.actionBlue);
      case 'in_progress':
        return (bg: const Color(0xFFE0E7FF), fg: const Color(0xFF4338CA));
      case 'blocked':
        return (bg: EchoTheme.dangerRedLight, fg: EchoTheme.dangerRed);
      case 'completed':
        return (bg: EchoTheme.successGreenLight, fg: EchoTheme.successGreen);
      case 'reopened':
        return (bg: EchoTheme.warningAmberLight, fg: EchoTheme.warningAmber);
      default:
        return (bg: EchoTheme.secondarySurface, fg: EchoTheme.textSecondary);
    }
  }

  static String labelForStatus(String status) {
    switch (status.toLowerCase().trim()) {
      case 'draft':
        return 'DRAFT';
      case 'processing':
        return 'PROCESSING';
      case 'needs_review':
        return 'NEEDS REVIEW';
      case 'ready':
        return 'READY FOR APPROVAL';
      case 'approved':
        return 'APPROVED';
      case 'assigned':
        return 'ASSIGNED';
      case 'in_progress':
        return 'IN PROGRESS';
      case 'blocked':
        return 'BLOCKED';
      case 'completed':
        return 'COMPLETED';
      case 'reopened':
        return 'REOPENED';
      default:
        return status.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = colorsForStatus(status);
    final label = customLabel ?? labelForStatus(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 12 : 8,
        vertical: isLarge ? 6 : 3,
      ),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.fg.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colors.fg,
          fontSize: isLarge ? 12 : 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
