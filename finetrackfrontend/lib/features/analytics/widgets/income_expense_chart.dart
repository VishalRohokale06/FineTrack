import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class IncomeExpenseChart extends StatelessWidget {
  const IncomeExpenseChart({super.key});

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
          Text("Income vs Expense", style: AppTextStyles.headingSmall),

          const SizedBox(height: 20),

          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 45,
                sections: [
                  PieChartSectionData(
                    value: 50,
                    color: AppColors.success,
                    title: "Income",
                    radius: 60,
                    titleStyle: AppTextStyles.labelSmall,
                  ),
                  PieChartSectionData(
                    value: 35,
                    color: AppColors.danger,
                    title: "Expense",
                    radius: 60,
                    titleStyle: AppTextStyles.labelSmall,
                  ),
                  PieChartSectionData(
                    value: 15,
                    color: AppColors.primary,
                    title: "Savings",
                    radius: 60,
                    titleStyle: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
