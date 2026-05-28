import 'package:finetrack/core/theme/app_colors.dart';
import 'package:finetrack/core/theme/app_text_styles.dart';
import 'package:finetrack/core/widgets/empty_state.dart';
import 'package:finetrack/core/widgets/loading_skeleton.dart';
import 'package:finetrack/features/expenses/models/expense_model.dart';
import 'package:finetrack/features/expenses/screens/edit_expense_screen.dart';
import 'package:finetrack/features/expenses/services/expense_service.dart';
import 'package:flutter/material.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final ExpenseService expenseService = ExpenseService();
  final TextEditingController searchController = TextEditingController();

  List<ExpenseModel> expenses = [];
  List<ExpenseModel> filteredExpenses = [];

  bool isLoading = true;

  String selectedCategory = "All";

  final categories = [
    "All",
    "Food",
    "Transport",
    "Shopping",
    "Health",
    "Bills",
  ];

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    try {
      final data = await expenseService.getExpenses();

      if (!mounted) return;

      setState(() {
        expenses = data;
        filteredExpenses = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load expenses")));
    }
  }

  void filterExpenses() {
    final searchText = searchController.text.toLowerCase();

    setState(() {
      filteredExpenses =
          expenses.where((expense) {
            final matchesSearch = expense.title.toLowerCase().contains(
              searchText,
            );

            final matchesCategory =
                selectedCategory == "All" ||
                expense.category == selectedCategory;

            return matchesSearch && matchesCategory;
          }).toList();
    });
  }

  Future<void> deleteExpense(int id) async {
    try {
      await expenseService.deleteExpense(id);
      await fetchExpenses();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Expense deleted")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Delete failed")));
    }
  }

  void showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Delete Expense"),
            content: const Text("Are you sure?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  deleteExpense(id);
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "food":
        return Icons.fastfood;
      case "transport":
        return Icons.directions_car;
      case "shopping":
        return Icons.shopping_bag;
      case "health":
        return Icons.health_and_safety;
      case "bills":
        return Icons.receipt_long;
      default:
        return Icons.account_balance_wallet;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("All Expenses")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (_) => filterExpenses(),
                  decoration: const InputDecoration(
                    hintText: "Search expenses...",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items:
                      categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedCategory = value;
                    });

                    filterExpenses();
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchExpenses,
              child:
                  isLoading
                      ? ListView(
                        padding: const EdgeInsets.all(20),
                        children: const [
                          LoadingSkeleton(height: 80, width: double.infinity),
                          SizedBox(height: 16),
                          LoadingSkeleton(height: 80, width: double.infinity),
                        ],
                      )
                      : filteredExpenses.isEmpty
                      ? ListView(
                        children: const [
                          SizedBox(height: 120),
                          EmptyState(
                            icon: Icons.search_off,
                            title: "No matching expenses",
                            subtitle: "Try changing search/filter.",
                          ),
                        ],
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = filteredExpenses[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.1,
                                ),
                                child: Icon(
                                  getCategoryIcon(expense.category),
                                  color: AppColors.primary,
                                ),
                              ),
                              title: Text(
                                expense.title,
                                style: AppTextStyles.bodyMedium,
                              ),
                              subtitle: Text(
                                "${expense.category} • ${expense.paymentMethod}",
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder:
                                    (_) => const [
                                      PopupMenuItem(
                                        value: "edit",
                                        child: Text("Edit"),
                                      ),
                                      PopupMenuItem(
                                        value: "delete",
                                        child: Text("Delete"),
                                      ),
                                    ],
                                onSelected: (value) async {
                                  if (value == "edit") {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => EditExpenseScreen(
                                              expense: expense,
                                            ),
                                      ),
                                    );

                                    if (result == true) {
                                      await fetchExpenses();
                                    }
                                  }

                                  if (value == "delete") {
                                    showDeleteDialog(expense.id);
                                  }
                                },
                                child: Text(
                                  "₹${expense.amount}",
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.danger,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
