import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Reusable Empty State widget for work order queues, search results, and evidence views.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    this.icon = Icons.task_alt_rounded,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onActionPressed,
    this.iconSize = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: EchoTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EchoTheme.borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: EchoTheme.textTertiary),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: EchoTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: EchoTheme.textSecondary,
              height: 1.35,
            ),
          ),
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onActionPressed,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                textStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
