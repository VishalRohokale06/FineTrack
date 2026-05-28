import 'package:finetrack/core/theme/app_text_styles.dart';
import 'package:finetrack/core/widgets/custom_button.dart';
import 'package:finetrack/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../services/expense_service.dart';
import '../widgets/amount_input.dart';
import '../widgets/category_selector.dart';
import '../widgets/payment_method_selector.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final amountController = TextEditingController();
  final notesController = TextEditingController();

  final ExpenseService expenseService = ExpenseService();

  bool isLoading = false;

  String selectedCategory = "Food";
  String selectedPaymentMethod = "UPI";

  Future<void> saveExpense() async {
    if (amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter amount")));
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      print("CATEGORY: $selectedCategory");
      print("PAYMENT: $selectedPaymentMethod");
      print("AMOUNT: ${amountController.text}");

      await expenseService.addExpense(
        title: selectedCategory,
        amount: double.parse(amountController.text.trim()),
        category: selectedCategory,
        paymentMethod: selectedPaymentMethod,
        notes: notesController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense added successfully")),
      );

      amountController.clear();
      notesController.clear();
    } catch (e) {
      print("ADD EXPENSE ERROR: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Add Expense")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AmountInput(controller: amountController),

            const SizedBox(height: 28),

            Text("Category", style: AppTextStyles.headingSmall),

            const SizedBox(height: 16),

            CategorySelector(
              onSelected: (value) {
                selectedCategory = value;
              },
            ),

            const SizedBox(height: 28),

            Text("Payment Method", style: AppTextStyles.headingSmall),

            const SizedBox(height: 16),

            PaymentMethodSelector(
              onSelected: (value) {
                selectedPaymentMethod = value;
              },
            ),

            const SizedBox(height: 28),

            Text("Notes", style: AppTextStyles.headingSmall),

            const SizedBox(height: 16),

            CustomTextfield(hintText: "Add Notes", controller: notesController),

            const SizedBox(height: 40),

            CustomButton(
              text: "Save Expense",
              isLoading: isLoading,
              onPressed: saveExpense,
            ),
          ],
        ),
      ),
    );
  }
}
