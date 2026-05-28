import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../services/budget_service.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final BudgetService budgetService = BudgetService();

  final limitController = TextEditingController();

  String selectedCategory = "Food";
  bool isLoading = false;

  final categories = ["Food", "Transport", "Shopping", "Health", "Bills"];

  Future<void> saveBudget() async {
    if (limitController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter budget amount")));
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await budgetService.createBudget(
        category: selectedCategory,
        limitAmount: double.parse(limitController.text.trim()),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Budget created successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $e")));
    } finally {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Create Budget")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category", style: AppTextStyles.headingSmall),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(hintText: "Select Category"),
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
              },
            ),

            const SizedBox(height: 24),

            Text("Budget Limit", style: AppTextStyles.headingSmall),

            const SizedBox(height: 16),

            CustomTextfield(
              hintText: "Enter amount",
              controller: limitController,
            ),

            const SizedBox(height: 40),

            CustomButton(
              text: "Save Budget",
              isLoading: isLoading,
              onPressed: saveBudget,
            ),
          ],
        ),
      ),
    );
  }
}
