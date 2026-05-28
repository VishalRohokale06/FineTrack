import 'package:flutter/material.dart';
import '../models/income_model.dart';
import '../services/income_service.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final IncomeService incomeService = IncomeService();

  List<IncomeModel> incomes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIncome();
  }

  Future<void> fetchIncome() async {
    try {
      final data = await incomeService.getIncome();

      setState(() {
        incomes = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteIncome(int id) async {
    await incomeService.deleteIncome(id);
    await fetchIncome();
  }

  Future<void> showAddIncomeDialog() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final notesController = TextEditingController();

    String category = "Salary";
    String paymentMethod = "Bank Transfer";

    await showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text("Add Income"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(hintText: "Title"),
                      ),
                      TextField(
                        controller: amountController,
                        decoration: const InputDecoration(hintText: "Amount"),
                      ),
                      TextField(
                        controller: notesController,
                        decoration: const InputDecoration(hintText: "Notes"),
                      ),
                      DropdownButton<String>(
                        value: category,
                        items: const [
                          DropdownMenuItem(
                            value: "Salary",
                            child: Text("Salary"),
                          ),
                          DropdownMenuItem(
                            value: "Freelance",
                            child: Text("Freelance"),
                          ),
                          DropdownMenuItem(
                            value: "Bonus",
                            child: Text("Bonus"),
                          ),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            category = value!;
                          });
                        },
                      ),
                      DropdownButton<String>(
                        value: paymentMethod,
                        items: const [
                          DropdownMenuItem(
                            value: "Bank Transfer",
                            child: Text("Bank Transfer"),
                          ),
                          DropdownMenuItem(value: "Cash", child: Text("Cash")),
                          DropdownMenuItem(value: "UPI", child: Text("UPI")),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            paymentMethod = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await incomeService.addIncome(
                        title: titleController.text.trim(),
                        amount: double.parse(amountController.text.trim()),
                        category: category,
                        paymentMethod: paymentMethod,
                        notes: notesController.text.trim(),
                      );

                      Navigator.pop(context);
                      await fetchIncome();
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
        title: const Text("Income"),
        actions: [
          IconButton(
            onPressed: showAddIncomeDialog,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: incomes.length,
                itemBuilder: (context, index) {
                  final income = incomes[index];

                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.arrow_downward),
                    ),
                    title: Text(income.title),
                    subtitle: Text(income.category),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("₹${income.amount}"),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteIncome(income.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
