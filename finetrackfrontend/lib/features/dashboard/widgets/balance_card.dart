import 'package:finetrack/features/dashboard/screens/dashboard_screen.dart';
import 'package:finetrack/features/income/screens/income_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class BalanceCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final VoidCallback onIncomeUpdated;

  const BalanceCard({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.onIncomeUpdated,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Net Balance", style: AppTextStyles.bodySmall),

          const SizedBox(height: 10),

          Text(
            "₹${netBalance.toStringAsFixed(0)}",
            style: AppTextStyles.amountLarge,
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _miniCard(
                  "Income",
                  "+ ₹${totalIncome.toStringAsFixed(0)}",
                  AppColors.success,
                  () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const IncomeScreen()),
                    );
                    onIncomeUpdated();
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _miniCard(
                  "Expense",
                  "- ₹${totalExpense.toStringAsFixed(0)}",
                  AppColors.danger,
                  null,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _miniCard(
                  "Saved",
                  "₹${netBalance.toStringAsFixed(0)}",
                  AppColors.primary,
                  null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniCard(
    String title,
    String amount,
    Color color,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title, style: AppTextStyles.labelSmall),

            const SizedBox(height: 6),

            Text(
              amount,
              style: AppTextStyles.labelLarge.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
