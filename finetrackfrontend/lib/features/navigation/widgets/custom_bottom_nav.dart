import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      Icons.home_outlined,
      Icons.analytics_outlined,
      Icons.add,
      Icons.account_balance_wallet_outlined,
      Icons.person_outline,
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                items[index],
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 26,
              ),
            ),
          );
        }),
      ),
    );
  }
}
