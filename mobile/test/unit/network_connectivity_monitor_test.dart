import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/core/network/network_connectivity_monitor.dart';

void main() {
  group('NetworkConnectivityMonitor Unit Tests', () {
    test('defaults to wifi status and online mode', () {
      final monitor = NetworkConnectivityMonitor();
      expect(monitor.currentStatus, equals(NetworkStatus.wifi));
      expect(monitor.isOnline, isTrue);
      expect(monitor.isWifi, isTrue);
      expect(monitor.canSync, isTrue);
    });

    test('updates status to offline and reports correct sync state', () {
      final monitor =
          NetworkConnectivityMonitor(initialStatus: NetworkStatus.wifi);
      monitor.updateStatus(NetworkStatus.offline);

      expect(monitor.currentStatus, equals(NetworkStatus.offline));
      expect(monitor.isOnline, isFalse);
      expect(monitor.isWifi, isFalse);
      expect(monitor.canSync, isFalse);
    });

    test('updates status to cellular', () {
      final monitor =
          NetworkConnectivityMonitor(initialStatus: NetworkStatus.offline);
      monitor.updateStatus(NetworkStatus.cellular);

      expect(monitor.currentStatus, equals(NetworkStatus.cellular));
      expect(monitor.isOnline, isTrue);
      expect(monitor.isWifi, isFalse);
      expect(monitor.canSync, isTrue);
    });
  });
}
