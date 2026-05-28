import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  String userName = "User";

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString("user_name"));
    setState(() {
      userName = prefs.getString("user_name") ?? "User";
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning 👋";
    } else if (hour < 17) {
      return "Good Afternoon ☀️";
    } else {
      return "Good Evening 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person, color: Colors.white, size: 28),
        ),

        const SizedBox(width: 14),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getGreeting(), style: AppTextStyles.bodySmall),

            const SizedBox(height: 4),

            Text(userName, style: AppTextStyles.headingMedium),
          ],
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: const Icon(
            Icons.notifications_none,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
