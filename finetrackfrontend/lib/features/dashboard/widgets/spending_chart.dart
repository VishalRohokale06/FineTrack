import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SpendingChart extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;

  const SpendingChart({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
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
          Text("Income vs Expense", style: AppTextStyles.headingSmall),

          const SizedBox(height: 20),

          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),

                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final labels = ["Income", "Expense"];

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            labels[value.toInt()],
                            style: AppTextStyles.labelSmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                barGroups: [
                  _bar(0, totalIncome, AppColors.success),
                  _bar(1, totalExpense, AppColors.danger),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 40,
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
      ],
    );
  }
}
