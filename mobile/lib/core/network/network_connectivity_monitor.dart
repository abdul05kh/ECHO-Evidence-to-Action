import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NetworkStatus {
  wifi,
  cellular,
  offline,
}

class NetworkConnectivityMonitor {
  NetworkStatus _status;

  NetworkConnectivityMonitor({NetworkStatus initialStatus = NetworkStatus.wifi})
      : _status = initialStatus;

  NetworkStatus get currentStatus => _status;

  bool get isOnline => _status != NetworkStatus.offline;

  bool get isWifi => _status == NetworkStatus.wifi;

  bool get canSync => isOnline;

  void updateStatus(NetworkStatus newStatus) {
    _status = newStatus;
  }
}

final networkConnectivityMonitorProvider =
    Provider((ref) => NetworkConnectivityMonitor());
