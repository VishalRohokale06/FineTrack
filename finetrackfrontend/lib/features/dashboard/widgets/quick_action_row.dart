import 'package:flutter/material.dart';

import '../../analytics/screens/analytics_screen.dart';
import '../../budgets/screens/budget_screen.dart';
import '../../expenses/screens/add_expense_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class QuickActionRow extends StatelessWidget {
  const QuickActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            context,
            icon: Icons.add,
            label: "Add Expense",
            color: AppColors.primary,
            screen: const AddExpenseScreen(),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _actionButton(
            context,
            icon: Icons.analytics,
            label: "Analytics",
            color: AppColors.success,
            screen: const AnalyticsScreen(),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _actionButton(
            context,
            icon: Icons.account_balance_wallet,
            label: "Budgets",
            color: AppColors.warning,
            screen: const BudgetScreen(),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),

            const SizedBox(height: 10),

            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
