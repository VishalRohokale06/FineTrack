import 'package:finetrack/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import '../models/recurring_expense_model.dart';
import '../services/recurring_expense_service.dart';

class RecurringExpenseScreen extends StatefulWidget {
  const RecurringExpenseScreen({super.key});

  @override
  State<RecurringExpenseScreen> createState() => _RecurringExpenseScreenState();
}

class _RecurringExpenseScreenState extends State<RecurringExpenseScreen> {
  final RecurringExpenseService service = RecurringExpenseService();

  List<RecurringExpenseModel> recurringExpenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecurringExpenses();
  }

  Future<void> fetchRecurringExpenses() async {
    try {
      final data = await service.getRecurringExpenses();

      if (!mounted) return;

      setState(() {
        recurringExpenses = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load recurring expenses")),
      );
    }
  }

  Future<void> deleteRecurring(int id) async {
    try {
      await service.deleteRecurringExpense(id);

      await fetchRecurringExpenses();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recurring expense deleted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Delete failed")));
    }
  }

  Future<void> showCreateDialog() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    String category = "Bills";
    String paymentMethod = "UPI";
    String frequency = "MONTHLY";

    await showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text("Create Recurring Expense"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(hintText: "Title"),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: "Amount"),
                      ),

                      const SizedBox(height: 12),

                      DropdownButton<String>(
                        value: category,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: "Bills",
                            child: Text("Bills"),
                          ),
                          DropdownMenuItem(value: "Food", child: Text("Food")),
                          DropdownMenuItem(
                            value: "Health",
                            child: Text("Health"),
                          ),
                          DropdownMenuItem(
                            value: "Shopping",
                            child: Text("Shopping"),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setDialogState(() {
                            category = value;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      DropdownButton<String>(
                        value: paymentMethod,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: "UPI", child: Text("UPI")),
                          DropdownMenuItem(value: "Cash", child: Text("Cash")),
                          DropdownMenuItem(value: "Card", child: Text("Card")),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setDialogState(() {
                            paymentMethod = value;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      DropdownButton<String>(
                        value: frequency,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: "DAILY",
                            child: Text("Daily"),
                          ),
                          DropdownMenuItem(
                            value: "WEEKLY",
                            child: Text("Weekly"),
                          ),
                          DropdownMenuItem(
                            value: "MONTHLY",
                            child: Text("Monthly"),
                          ),
                          DropdownMenuItem(
                            value: "YEARLY",
                            child: Text("Yearly"),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setDialogState(() {
                            frequency = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),

                  TextButton(
                    onPressed: () async {
                      if (titleController.text.trim().isEmpty ||
                          amountController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Fill all required fields"),
                          ),
                        );
                        return;
                      }

                      try {
                        await service.createRecurringExpense(
                          title: titleController.text.trim(),
                          amount: double.parse(amountController.text.trim()),
                          category: category,
                          paymentMethod: paymentMethod,
                          frequency: frequency,
                        );

                        await NotificationService.showNotification(
                          title: "Recurring Expense Created",
                          body:
                              "${titleController.text.trim()} "
                              "will repeat $frequency",
                        );

                        if (!mounted) return;

                        Navigator.pop(context);

                        await fetchRecurringExpenses();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Recurring expense created"),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Creation failed")),
                        );
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recurring Expenses"),
        actions: [
          IconButton(onPressed: showCreateDialog, icon: const Icon(Icons.add)),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : recurringExpenses.isEmpty
              ? const Center(child: Text("No recurring expenses"))
              : ListView.builder(
                itemCount: recurringExpenses.length,
                itemBuilder: (context, index) {
                  final item = recurringExpenses[index];

                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(
                      "${item.frequency} • Next: ${item.nextDueDate}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("₹${item.amount}"),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteRecurring(item.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
