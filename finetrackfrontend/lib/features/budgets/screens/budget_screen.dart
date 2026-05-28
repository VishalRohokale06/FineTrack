import 'package:finetrack/core/services/notification_service.dart';
import 'package:finetrack/core/theme/app_text_styles.dart';
import 'package:finetrack/core/widgets/empty_state.dart';
import 'package:finetrack/core/widgets/loading_skeleton.dart';
import 'package:finetrack/features/budgets/models/budget_model.dart';
import 'package:finetrack/features/budgets/screens/add_budget_screen.dart';
import 'package:finetrack/features/budgets/services/budget_service.dart';
import 'package:finetrack/features/budgets/widgets/budget_progress_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../widgets/budget_alert_card.dart';
import '../widgets/budget_summary_card.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final BudgetService budgetService = BudgetService();

  List<BudgetModel> budgets = [];
  List<BudgetAlertModel> alerts = [];
  BudgetSummaryModel? summary;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBudgetData();
  }

  Future<void> fetchBudgetData() async {
    try {
      final fetchedBudgets = await budgetService.getBudgets();
      final fetchedAlerts = await budgetService.getAlerts();
      final fetchedSummary = await budgetService.getSummary();

      if (!mounted) return;

      setState(() {
        budgets = fetchedBudgets;
        alerts = fetchedAlerts;
        summary = fetchedSummary;
        isLoading = false;
      });

      for (final alert in fetchedAlerts) {
        await NotificationService.showNotification(
          title: "Budget Alert",
          body:
              "${alert.category} budget exceeded! "
              "Spent ₹${alert.spentAmount}",
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load budget data")),
      );
    }
  }

  Color getProgressColor(double progress) {
    if (progress < 0.6) {
      return AppColors.success;
    } else if (progress < 0.85) {
      return AppColors.warning;
    } else {
      return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Budgets"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddBudgetScreen()),
              );

              if (result == true) {
                fetchBudgetData();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchBudgetData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoading) ...[
                const LoadingSkeleton(height: 120, width: double.infinity),

                const SizedBox(height: 20),

                const LoadingSkeleton(height: 300, width: double.infinity),
              ] else ...[
                BudgetSummaryCard(
                  totalBudget: summary?.totalBudget ?? 0,
                  totalSpent: summary?.totalSpent ?? 0,
                  remainingAmount: summary?.remainingAmount ?? 0,
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 28),

                Text("Category Budgets", style: AppTextStyles.headingSmall),

                const SizedBox(height: 18),

                if (budgets.isEmpty)
                  const EmptyState(
                    icon: Icons.account_balance_wallet_outlined,
                    title: "No Budgets Yet",
                    subtitle: "Create budgets to track spending limits.",
                  )
                else
                  ...budgets.map((budget) {
                    final progress =
                        budget.limitAmount == 0
                            ? 0.0
                            : (budget.spentAmount / budget.limitAmount);

                    return BudgetProgressTile(
                      category: budget.category,
                      amount: "₹${budget.spentAmount} / ₹${budget.limitAmount}",
                      progress: progress > 1 ? 1 : progress,
                      progressColor: getProgressColor(progress),
                    );
                  }),

                const SizedBox(height: 20),

                if (alerts.isNotEmpty)
                  ...alerts.map(
                    (alert) => BudgetAlertCard(
                      title: alert.category,
                      subtitle:
                          "Spent ₹${alert.spentAmount} / ₹${alert.budgetLimit}",
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
