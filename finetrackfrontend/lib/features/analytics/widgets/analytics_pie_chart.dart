import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/analytics_model.dart';

class AnalyticsPieChart extends StatelessWidget {
  final List<CategoryBreakdownModel> categoryData;
  final double totalExpenses;

  const AnalyticsPieChart({
    super.key,
    required this.categoryData,
    required this.totalExpenses,
  });

  Color getCategoryColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.danger,
      Colors.purple,
      Colors.teal,
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 55,
          sectionsSpace: 3,
          sections:
              categoryData.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                final percent =
                    totalExpenses == 0
                        ? 0
                        : (item.amount / totalExpenses) * 100;

                return PieChartSectionData(
                  value: item.amount,
                  title: "${percent.toStringAsFixed(0)}%",
                  radius: 80,
                  color: getCategoryColor(index),
                  titleStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
