import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CategorySelector extends StatefulWidget {
  final Function(String) onSelected;

  const CategorySelector({super.key, required this.onSelected});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final categories = ["Food", "Transport", "Shopping", "Health", "Bills"];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.onSelected(categories[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(categories.length, (index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });

            widget.onSelected(categories[index]);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              categories[index],
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }),
    );
  }
}
