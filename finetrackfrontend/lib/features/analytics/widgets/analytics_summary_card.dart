import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AnalyticsSummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color amountColor;

  const AnalyticsSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Text(title, style: AppTextStyles.bodySmall),
          const SizedBox(height: 10),
          Text(
            amount,
            style: AppTextStyles.headingSmall.copyWith(color: amountColor),
          ),
        ],
      ),
    );
  }
}
