import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class BudgetProgressTile extends StatelessWidget {
  final String category;
  final String amount;
  final double progress;
  final Color progressColor;

  const BudgetProgressTile({
    super.key,
    required this.category,
    required this.amount,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(category, style: AppTextStyles.bodyMedium),
              const Spacer(),
              Text(amount, style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.background,
            valueColor: AlwaysStoppedAnimation(progressColor),
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
    );
  }
}
