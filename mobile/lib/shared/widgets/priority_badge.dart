import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Standardized Priority Badge widget across ECHO work order views.
class PriorityBadge extends StatelessWidget {
  final String priority;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.fontSize = 11.5,
    this.padding = const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    final normalized = priority.trim().toLowerCase();
    final Color bgColor;
    final Color textColor;
    final Color borderColor;
    final String label;

    switch (normalized) {
      case 'critical':
        bgColor = EchoTheme.dangerRedLight;
        textColor = EchoTheme.dangerRed;
        borderColor = EchoTheme.dangerRed.withValues(alpha: 0.3);
        label = 'CRITICAL';
        break;
      case 'high':
        bgColor = EchoTheme.warningAmberLight;
        textColor = EchoTheme.warningAmber;
        borderColor = EchoTheme.warningAmber.withValues(alpha: 0.3);
        label = 'HIGH';
        break;
      case 'medium':
        bgColor = EchoTheme.accentGoldLight;
        textColor = EchoTheme.accentGoldDark;
        borderColor = EchoTheme.accentGoldDark.withValues(alpha: 0.3);
        label = 'MEDIUM';
        break;
      case 'low':
      default:
        bgColor = EchoTheme.secondarySurface;
        textColor = EchoTheme.textSecondary;
        borderColor = EchoTheme.borderColor;
        label = 'LOW';
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
