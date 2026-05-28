import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class RecentTransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;

  const RecentTransactionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: Text(
        amount,
        style: AppTextStyles.labelLarge.copyWith(color: amountColor),
      ),
    );
  }
}
