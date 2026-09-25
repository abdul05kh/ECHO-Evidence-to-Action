import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/sync/sync_outbox_manager.dart';

class SyncOutboxStatusCard extends StatelessWidget {
  final SyncOutboxSummary summary;
  final VoidCallback? onSyncPressed;

  const SyncOutboxStatusCard({
    super.key,
    required this.summary,
    this.onSyncPressed,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = summary.hasPendingWork
        ? EchoTheme.accentGold
        : (summary.failedCount > 0
            ? EchoTheme.dangerRed
            : EchoTheme.successGreen);

    return Container(
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
              Icon(Icons.sync_rounded, size: 20, color: statusColor),
              const SizedBox(width: 8),
              const Text(
                'OFFLINE OUTBOX QUEUE',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: EchoTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(38),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  summary.hasPendingWork
                      ? '${summary.pendingCount} PENDING'
                      : (summary.failedCount > 0
                          ? '${summary.failedCount} FAILED'
                          : 'ALL SYNCED'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem('TOTAL', '${summary.totalCount}'),
              _statItem('PENDING', '${summary.pendingCount}'),
              _statItem('SYNCED', '${summary.syncedCount}'),
              _statItem('FAILED', '${summary.failedCount}'),
            ],
          ),
          if (summary.hasPendingWork && onSyncPressed != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSyncPressed,
                icon: const Icon(Icons.cloud_upload_rounded, size: 16),
                label: const Text('SYNC PENDING NOW'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: EchoTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: EchoTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
