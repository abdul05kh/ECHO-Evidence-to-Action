import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Branded ECHO loading indicator with iQOO golden accent styling and sub-caption text.
class EchoLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;

  const EchoLoadingIndicator({
    super.key,
    this.message,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(
            strokeWidth: 3.2,
            valueColor: AlwaysStoppedAnimation<Color>(EchoTheme.accentGold),
            backgroundColor: EchoTheme.secondarySurface,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 14),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: EchoTheme.textSecondary,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ],
    );
  }
}
