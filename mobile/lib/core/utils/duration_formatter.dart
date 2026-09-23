/// Standardized duration formatting utility for audio recording & capture timers.
class EchoDurationFormatter {
  static String formatMs(int? milliseconds) {
    if (milliseconds == null || milliseconds <= 0) {
      return '00:00';
    }
    final totalSeconds = (milliseconds / 1000).floor();
    final minutes = (totalSeconds / 60).floor();
    final seconds = totalSeconds % 60;
    final minStr = minutes.toString().padLeft(2, '0');
    final secStr = seconds.toString().padLeft(2, '0');
    return '$minStr:$secStr';
  }

  static String formatSeconds(int totalSeconds) {
    if (totalSeconds <= 0) return '00:00';
    final minutes = (totalSeconds / 60).floor();
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
  }
}
