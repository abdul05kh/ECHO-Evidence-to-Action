class EvidenceStorageSizeCalculator {
  static String formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      final kb = (bytes / 1024).toStringAsFixed(1);
      return '$kb KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      final mb = (bytes / (1024 * 1024)).toStringAsFixed(1);
      return '$mb MB';
    }
    final gb = (bytes / (1024 * 1024 * 1024)).toStringAsFixed(2);
    return '$gb GB';
  }

  static int calculateTotalSizeBytes(List<int> itemSizes) {
    return itemSizes.fold(0, (sum, size) => sum + size);
  }
}
