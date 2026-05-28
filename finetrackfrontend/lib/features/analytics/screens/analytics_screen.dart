import 'package:finetrack/core/theme/app_colors.dart';
import 'package:finetrack/core/theme/app_text_styles.dart';
import 'package:finetrack/core/widgets/empty_state.dart';
import 'package:finetrack/core/widgets/loading_skeleton.dart';
import 'package:finetrack/features/analytics/models/ai_insight_model.dart';
import 'package:finetrack/features/analytics/models/analytics_model.dart';
import 'package:finetrack/features/analytics/services/analytics_service.dart';
import 'package:finetrack/features/analytics/services/pdf_service.dart';
import 'package:finetrack/features/analytics/widgets/analytics_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AnalyticsService analyticsService = AnalyticsService();
  final PdfService pdfService = PdfService();

  AnalyticsModel? analyticsData;

  bool isLoading = true;

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  AIInsightModel? aiInsights;

  final months = const [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  @override
  void initState() {
    super.initState();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    try {
      final analytics = await analyticsService.getMonthlyAnalytics(
        month: selectedMonth,
        year: selectedYear,
      );

      final insights = await analyticsService.getAIInsights(
        month: selectedMonth,
        year: selectedYear,
      );

      if (!mounted) return;

      setState(() {
        analyticsData = analytics;
        aiInsights = insights;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load analytics")));
    }
  }

  Color getCategoryColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.danger,
    ];

    return colors[index % colors.length];
  }

  Future<void> exportPdf() async {
    if (analyticsData == null) return;

    final monthName = months[selectedMonth - 1];

    final pdfBytes = await pdfService.generateMonthlyReport(
      analytics: analyticsData!,
      monthName: monthName,
      year: selectedYear,
    );

    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Analytics"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: exportPdf,
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: fetchAnalytics,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<int>(
                value: selectedMonth,
                items: List.generate(
                  12,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text(months[index]),
                  ),
                ),
                onChanged: (value) async {
                  if (value == null) return;

                  setState(() {
                    selectedMonth = value;
                    isLoading = true;
                    analyticsData = null;
                    aiInsights = null;
                  });

                  await fetchAnalytics();
                },
              ),

              const SizedBox(height: 24),

              if (isLoading) ...[
                const LoadingSkeleton(height: 100, width: double.infinity),
                const SizedBox(height: 20),
                const LoadingSkeleton(height: 250, width: double.infinity),
              ] else if (analyticsData == null ||
                  analyticsData!.categoryBreakdown.isEmpty) ...[
                const SizedBox(height: 120),

                const EmptyState(
                  icon: Icons.analytics_outlined,
                  title: "No Analytics Available",
                  subtitle: "No expenses for this month.",
                ),
              ] else ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "Total Monthly Expense",
                          style: AppTextStyles.headingSmall,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "₹${analyticsData!.totalExpenses}",
                          style: AppTextStyles.headingLarge.copyWith(
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Text("Category Breakdown", style: AppTextStyles.headingSmall),

                const SizedBox(height: 20),

                AnalyticsPieChart(
                  categoryData: analyticsData!.categoryBreakdown,
                  totalExpenses: analyticsData!.totalExpenses,
                ),

                const SizedBox(height: 24),

                ...analyticsData!.categoryBreakdown.asMap().entries.map((
                  entry,
                ) {
                  final index = entry.key;
                  final item = entry.value;

                  final percent =
                      analyticsData!.totalExpenses == 0
                          ? 0
                          : (item.amount / analyticsData!.totalExpenses) * 100;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: getCategoryColor(index),
                        radius: 8,
                      ),
                      title: Text(item.category),
                      subtitle: Text(
                        "${percent.toStringAsFixed(1)}% of total spending",
                      ),
                      trailing: Text("₹${item.amount}"),
                    ),
                  );
                }),
                const SizedBox(height: 28),

                Text("AI Insights", style: AppTextStyles.headingSmall),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          aiInsights?.insights.map((insight) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.auto_awesome,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(insight)),
                                ],
                              ),
                            );
                          }).toList() ??
                          [],
                    ),
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
