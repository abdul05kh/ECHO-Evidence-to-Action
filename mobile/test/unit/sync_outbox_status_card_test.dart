import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/sync_outbox_status_card.dart';
import 'package:echo_mobile/core/sync/sync_outbox_manager.dart';

void main() {
  group('SyncOutboxStatusCard Widget Tests', () {
    testWidgets('renders all-synced state correctly',
        (WidgetTester tester) async {
      const summary = SyncOutboxSummary(
        totalCount: 5,
        pendingCount: 0,
        syncingCount: 0,
        syncedCount: 5,
        failedCount: 0,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SyncOutboxStatusCard(summary: summary),
          ),
        ),
      );

      expect(find.text('ALL SYNCED'), findsOneWidget);
      expect(find.text('OFFLINE OUTBOX QUEUE'), findsOneWidget);
      expect(find.text('SYNC PENDING NOW'), findsNothing);
    });

    testWidgets('renders pending state and triggers sync callback',
        (WidgetTester tester) async {
      bool syncTapped = false;
      const summary = SyncOutboxSummary(
        totalCount: 3,
        pendingCount: 2,
        syncingCount: 0,
        syncedCount: 1,
        failedCount: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SyncOutboxStatusCard(
              summary: summary,
              onSyncPressed: () {
                syncTapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('2 PENDING'), findsOneWidget);
      expect(find.text('SYNC PENDING NOW'), findsOneWidget);

      await tester.tap(find.text('SYNC PENDING NOW'));
      await tester.pump();

      expect(syncTapped, isTrue);
    });
  });
}
