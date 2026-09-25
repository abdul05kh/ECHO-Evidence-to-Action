import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/echo_network_status_badge.dart';
import 'package:echo_mobile/core/network/network_connectivity_monitor.dart';

void main() {
  group('EchoNetworkStatusBadge Widget Tests', () {
    testWidgets('renders wifi online badge correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EchoNetworkStatusBadge(status: NetworkStatus.wifi),
          ),
        ),
      );

      expect(find.text('ONLINE (WIFI)'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_rounded), findsOneWidget);
    });

    testWidgets('renders offline badge correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EchoNetworkStatusBadge(status: NetworkStatus.offline),
          ),
        ),
      );

      expect(find.text('OFFLINE (LOCAL QUEUE)'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    });

    testWidgets('renders cellular badge correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EchoNetworkStatusBadge(status: NetworkStatus.cellular),
          ),
        ),
      );

      expect(find.text('ONLINE (CELLULAR)'), findsOneWidget);
      expect(find.byIcon(Icons.signal_cellular_alt_rounded), findsOneWidget);
    });
  });
}
