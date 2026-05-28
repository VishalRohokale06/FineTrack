import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppSnackbar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surface,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
