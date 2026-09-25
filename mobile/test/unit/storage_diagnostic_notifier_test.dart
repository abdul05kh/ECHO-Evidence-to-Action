import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/settings/storage_diagnostic_notifier.dart';

void main() {
  group('StorageDiagnosticNotifier Unit Tests', () {
    late StorageDiagnosticNotifier notifier;

    setUp(() {
      notifier = StorageDiagnosticNotifier(
        initialState: const StorageDiagnosticState(
          databaseSizeBytes: 1000,
          attachmentSizeBytes: 5000,
          cachedFileCount: 5,
        ),
      );
    });

    test('calculates total size bytes correctly', () {
      expect(notifier.state.totalSizeBytes, equals(6000));
    });

    test('updates storage usage stats', () {
      notifier.updateStorageUsage(
        dbBytes: 2000,
        attachmentBytes: 8000,
        fileCount: 10,
      );

      expect(notifier.state.databaseSizeBytes, equals(2000));
      expect(notifier.state.attachmentSizeBytes, equals(8000));
      expect(notifier.state.totalSizeBytes, equals(10000));
      expect(notifier.state.cachedFileCount, equals(10));
    });

    test('clears attachment cache', () {
      notifier.clearCache();
      expect(notifier.state.attachmentSizeBytes, equals(0));
      expect(notifier.state.cachedFileCount, equals(0));
      expect(notifier.state.databaseSizeBytes, equals(1000));
    });
  });
}
