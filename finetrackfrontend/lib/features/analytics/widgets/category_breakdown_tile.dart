import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CategoryBreakdownTile extends StatelessWidget {
  final String category;
  final String amount;
  final String percent;
  final Color color;

  const CategoryBreakdownTile({
    super.key,
    required this.category,
    required this.amount,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 8, backgroundColor: color),
          const SizedBox(width: 14),

          Expanded(child: Text(category, style: AppTextStyles.bodyMedium)),

          Text(amount, style: AppTextStyles.bodyMedium),

          const SizedBox(width: 10),

          Text(percent, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
