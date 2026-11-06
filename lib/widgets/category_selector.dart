import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CategorySelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onChanged;
  const CategorySelector({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: incidentCategories.map((c) {
        final isSelected = selected == c.key;
        final colors = categoryGradient(c.key);
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onChanged(c.key),
          child: Container(
            width: 96,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : null,
              color: isSelected ? null : scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isSelected ? Colors.transparent : scheme.outlineVariant),
            ),
            child: Column(children: [
              Icon(c.icon, color: isSelected ? Colors.white : colors.last),
              const SizedBox(height: 6),
              Text(c.label,
                  style: TextStyle(
                      fontSize: 12, color: isSelected ? Colors.white : scheme.onSurface)),
            ]),
          ),
        );
      }).toList(),
    );
  }
}
