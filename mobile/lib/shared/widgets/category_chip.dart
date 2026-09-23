import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Reusable Category Chip widget with domain-specific icon cues.
class CategoryChip extends StatelessWidget {
  final String category;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const CategoryChip({
    super.key,
    required this.category,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  });

  @override
  Widget build(BuildContext context) {
    final normalized = category.trim().toLowerCase();
    final IconData icon;
    final String label;

    switch (normalized) {
      case 'it_peripheral':
      case 'it':
        icon = Icons.computer_rounded;
        label = 'IT & Peripheral';
        break;
      case 'electrical':
        icon = Icons.bolt_rounded;
        label = 'Electrical';
        break;
      case 'hvac':
        icon = Icons.ac_unit_rounded;
        label = 'HVAC & Climate';
        break;
      case 'plumbing':
        icon = Icons.water_drop_rounded;
        label = 'Plumbing';
        break;
      case 'equipment':
        icon = Icons.precision_manufacturing_rounded;
        label = 'Equipment';
        break;
      case 'furniture':
        icon = Icons.chair_rounded;
        label = 'Furniture';
        break;
      case 'facility':
      default:
        icon = Icons.build_circle_rounded;
        label = category.toUpperCase();
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: EchoTheme.secondarySurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EchoTheme.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize + 3, color: EchoTheme.textSecondary),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: EchoTheme.textPrimary,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}
