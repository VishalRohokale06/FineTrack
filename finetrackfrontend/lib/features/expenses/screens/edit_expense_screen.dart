import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../models/expense_model.dart';
import '../services/expense_service.dart';

class EditExpenseScreen extends StatefulWidget {
  final ExpenseModel expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final ExpenseService expenseService = ExpenseService();

  late TextEditingController titleController;
  late TextEditingController amountController;
  late TextEditingController notesController;

  bool isLoading = false;

  String selectedCategory = "Food";
  String selectedPaymentMethod = "UPI";

  final categories = ["Food", "Transport", "Shopping", "Health", "Bills"];

  final paymentMethods = ["UPI", "Cash", "Card"];

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.expense.title);

    amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );

    notesController = TextEditingController(text: widget.expense.notes);

    selectedCategory = widget.expense.category;
    selectedPaymentMethod = widget.expense.paymentMethod;
  }

  Future<void> updateExpense() async {
    if (titleController.text.trim().isEmpty ||
        amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Fill required fields")));
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await expenseService.updateExpense(
        id: widget.expense.id,
        title: titleController.text.trim(),
        amount: double.parse(amountController.text.trim()),
        category: selectedCategory,
        paymentMethod: selectedPaymentMethod,
        notes: notesController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Expense updated")));

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    } finally {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Edit Expense")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title", style: AppTextStyles.headingSmall),

            const SizedBox(height: 12),

            CustomTextfield(
              hintText: "Expense title",
              controller: titleController,
            ),

            const SizedBox(height: 24),

            Text("Amount", style: AppTextStyles.headingSmall),

            const SizedBox(height: 12),

            CustomTextfield(
              hintText: "Enter amount",
              controller: amountController,
            ),

            const SizedBox(height: 24),

            Text("Category", style: AppTextStyles.headingSmall),

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
              },
            ),

            const SizedBox(height: 24),

            Text("Payment Method", style: AppTextStyles.headingSmall),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedPaymentMethod,
              items:
                  paymentMethods
                      .map(
                        (method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),

            const SizedBox(height: 24),

            Text("Notes", style: AppTextStyles.headingSmall),

            const SizedBox(height: 12),

            CustomTextfield(hintText: "Notes", controller: notesController),

            const SizedBox(height: 40),

            CustomButton(
              text: "Update Expense",
              isLoading: isLoading,
              onPressed: updateExpense,
            ),
          ],
        ),
      ),
    );
  }
}
