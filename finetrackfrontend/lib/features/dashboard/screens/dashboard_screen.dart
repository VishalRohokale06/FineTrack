import 'package:finetrack/core/theme/app_colors.dart';
import 'package:finetrack/core/theme/app_text_styles.dart';
import 'package:finetrack/core/widgets/empty_state.dart';
import 'package:finetrack/core/widgets/loading_skeleton.dart';
import 'package:finetrack/features/chatbotai/screens/chat_screen.dart';
import 'package:finetrack/features/dashboard/models/dashboard_model.dart';
import 'package:finetrack/features/dashboard/services/dashboard_service.dart';
import 'package:finetrack/features/dashboard/widgets/dashboard_header.dart';
import 'package:finetrack/features/dashboard/widgets/quick_action_row.dart';
import 'package:finetrack/features/dashboard/widgets/recent_transaction_tile.dart';
import 'package:finetrack/features/dashboard/widgets/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/balance_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService dashboardService = DashboardService();

  DashboardModel? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final data = await dashboardService.getDashboardData();

      if (!mounted) return;

      setState(() {
        dashboardData = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load dashboard data")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      /////////////cahtbot button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatScreen()),
          );
        },
        icon: const Icon(Icons.smart_toy),
        label: const Text("AI"),
      ),
      ///////////////////
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: RefreshIndicator(
            onRefresh: fetchDashboardData,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeader(),

                  const SizedBox(height: 24),

                  if (isLoading) ...[
                    const LoadingSkeleton(height: 180, width: double.infinity),

                    const SizedBox(height: 20),

                    const LoadingSkeleton(height: 100, width: double.infinity),

                    const SizedBox(height: 20),

                    const LoadingSkeleton(height: 220, width: double.infinity),
                  ] else ...[
                    BalanceCard(
                      totalIncome: dashboardData?.totalIncome ?? 0,
                      totalExpense: dashboardData?.totalExpense ?? 0,
                      netBalance: dashboardData?.netBalance ?? 0,
                      onIncomeUpdated: fetchDashboardData,
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),

                    const SizedBox(height: 20),

                    const QuickActionRow()
                        .animate()
                        .fadeIn(delay: 150.ms)
                        .slideY(begin: 0.2),

                    const SizedBox(height: 24),

                    SpendingChart(
                      totalIncome: dashboardData?.totalIncome ?? 0,
                      totalExpense: dashboardData?.totalExpense ?? 0,
                    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.2),

                    const SizedBox(height: 24),

                    Text(
                      "Recent Transactions",
                      style: AppTextStyles.headingSmall,
                    ),

                    const SizedBox(height: 16),

                    if (dashboardData == null ||
                        dashboardData!.recentExpenses.isEmpty)
                      const EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: "No Transactions Yet",
                        subtitle:
                            "Start adding expenses to track your spending.",
                      )
                    else
                      ...dashboardData!.recentExpenses.map(
                        (expense) => RecentTransactionTile(
                          icon: Icons.account_balance_wallet,
                          title: expense.title,
                          subtitle: expense.category,
                          amount: "- ₹${expense.amount}",
                          amountColor: AppColors.danger,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
