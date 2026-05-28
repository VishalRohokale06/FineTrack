import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;

  const AmountInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          Text("Amount", style: AppTextStyles.bodySmall),

          const SizedBox(height: 10),

          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: AppTextStyles.amountLarge,

            decoration: const InputDecoration(
              hintText: "₹0",
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
