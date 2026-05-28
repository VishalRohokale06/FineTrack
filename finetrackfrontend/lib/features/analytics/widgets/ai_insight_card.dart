import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AIInsightCard extends StatelessWidget {
  const AIInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary, width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.primary),
          const SizedBox(width: 14),

          Expanded(
            child: Text(
              "AI Insight: Food spending increased 18% compared to last month.",
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
