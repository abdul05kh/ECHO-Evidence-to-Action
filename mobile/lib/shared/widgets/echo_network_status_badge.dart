import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/network/network_connectivity_monitor.dart';

class EchoNetworkStatusBadge extends StatelessWidget {
  final NetworkStatus status;

  const EchoNetworkStatusBadge({
    super.key,
    required this.status,
  });

  Color get _badgeColor {
    switch (status) {
      case NetworkStatus.wifi:
        return EchoTheme.successGreen;
      case NetworkStatus.cellular:
        return EchoTheme.actionBlue;
      case NetworkStatus.offline:
        return EchoTheme.accentGold;
    }
  }

  String get _badgeText {
    switch (status) {
      case NetworkStatus.wifi:
        return 'ONLINE (WIFI)';
      case NetworkStatus.cellular:
        return 'ONLINE (CELLULAR)';
      case NetworkStatus.offline:
        return 'OFFLINE (LOCAL QUEUE)';
    }
  }

  IconData get _badgeIcon {
    switch (status) {
      case NetworkStatus.wifi:
        return Icons.wifi_rounded;
      case NetworkStatus.cellular:
        return Icons.signal_cellular_alt_rounded;
      case NetworkStatus.offline:
        return Icons.wifi_off_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _badgeColor.withAlpha(38),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _badgeColor.withAlpha(153)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_badgeIcon, size: 12, color: _badgeColor),
          const SizedBox(width: 6),
          Text(
            _badgeText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _badgeColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
