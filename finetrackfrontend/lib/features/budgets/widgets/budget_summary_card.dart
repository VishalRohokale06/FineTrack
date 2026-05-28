import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class BudgetSummaryCard extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final double remainingAmount;

  const BudgetSummaryCard({
    super.key,
    required this.totalBudget,
    required this.totalSpent,
    required this.remainingAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _item(
              "Budget",
              "₹${totalBudget.toStringAsFixed(0)}",
              AppColors.textPrimary,
            ),
          ),

          _divider(),

          Expanded(
            child: _item(
              "Used",
              "₹${totalSpent.toStringAsFixed(0)}",
              AppColors.danger,
            ),
          ),

          _divider(),

          Expanded(
            child: _item(
              "Left",
              "₹${remainingAmount.toStringAsFixed(0)}",
              AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 40, color: AppColors.border);
  }

  Widget _item(String title, String amount, Color color) {
    return Column(
      children: [
        Text(title, style: AppTextStyles.bodySmall),

        const SizedBox(height: 8),

        Text(
          amount,
          textAlign: TextAlign.center,
          style: AppTextStyles.headingSmall.copyWith(color: color),
        ),
      ],
    );
  }
}
