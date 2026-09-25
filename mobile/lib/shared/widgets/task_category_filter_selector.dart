import 'package:flutter/material.dart';
import '../../app/theme.dart';

class TaskCategoryFilterSelector extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const TaskCategoryFilterSelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All Categories'),
            selected: selectedCategory == null,
            onSelected: (_) => onCategorySelected(null),
            selectedColor: EchoTheme.accentGold.withAlpha(51),
            backgroundColor: EchoTheme.surfaceColor,
            labelStyle: TextStyle(
              fontSize: 11,
              fontWeight:
                  selectedCategory == null ? FontWeight.w700 : FontWeight.w500,
              color: selectedCategory == null
                  ? EchoTheme.accentGold
                  : EchoTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 6),
          ...categories.map((cat) {
            final isSelected =
                selectedCategory?.toLowerCase() == cat.toLowerCase();
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(cat.toUpperCase()),
                selected: isSelected,
                onSelected: (_) => onCategorySelected(isSelected ? null : cat),
                selectedColor: EchoTheme.accentGold.withAlpha(51),
                backgroundColor: EchoTheme.surfaceColor,
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? EchoTheme.accentGold
                      : EchoTheme.textSecondary,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
