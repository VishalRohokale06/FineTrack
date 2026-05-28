import 'package:finetrack/features/analytics/screens/analytics_screen.dart';
import 'package:finetrack/features/budgets/screens/budget_screen.dart';
import 'package:finetrack/features/dashboard/screens/dashboard_screen.dart';
import 'package:finetrack/features/expenses/screens/add_expense_screen.dart';
import 'package:finetrack/features/navigation/widgets/custom_bottom_nav.dart';
import 'package:finetrack/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    DashboardScreen(),
    AnalyticsScreen(),
    AddExpenseScreen(),
    BudgetScreen(),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),

      bottomNavigationBar: CustomBottomNav(
        selectedIndex: selectedIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
