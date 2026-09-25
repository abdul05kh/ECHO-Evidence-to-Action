import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageDiagnosticState {
  final int databaseSizeBytes;
  final int attachmentSizeBytes;
  final int cachedFileCount;

  const StorageDiagnosticState({
    required this.databaseSizeBytes,
    required this.attachmentSizeBytes,
    required this.cachedFileCount,
  });

  int get totalSizeBytes => databaseSizeBytes + attachmentSizeBytes;

  StorageDiagnosticState copyWith({
    int? databaseSizeBytes,
    int? attachmentSizeBytes,
    int? cachedFileCount,
  }) {
    return StorageDiagnosticState(
      databaseSizeBytes: databaseSizeBytes ?? this.databaseSizeBytes,
      attachmentSizeBytes: attachmentSizeBytes ?? this.attachmentSizeBytes,
      cachedFileCount: cachedFileCount ?? this.cachedFileCount,
    );
  }
}

class StorageDiagnosticNotifier extends StateNotifier<StorageDiagnosticState> {
  StorageDiagnosticNotifier({
    StorageDiagnosticState initialState = const StorageDiagnosticState(
      databaseSizeBytes: 204800,
      attachmentSizeBytes: 10485760,
      cachedFileCount: 14,
    ),
  }) : super(initialState);

  void updateStorageUsage({
    required int dbBytes,
    required int attachmentBytes,
    required int fileCount,
  }) {
    state = StorageDiagnosticState(
      databaseSizeBytes: dbBytes,
      attachmentSizeBytes: attachmentBytes,
      cachedFileCount: fileCount,
    );
  }

  void clearCache() {
    state = state.copyWith(
      attachmentSizeBytes: 0,
      cachedFileCount: 0,
    );
  }
}

final storageDiagnosticProvider =
    StateNotifierProvider<StorageDiagnosticNotifier, StorageDiagnosticState>(
        (ref) => StorageDiagnosticNotifier());
