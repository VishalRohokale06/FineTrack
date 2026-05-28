import '../../expenses/models/expense_model.dart';

class DashboardModel {
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final List<ExpenseModel> recentExpenses;

  DashboardModel({
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.recentExpenses,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final rawList =
        json["recentExpense"]; // backend field is "recentExpense" (singular)
    final List<ExpenseModel> recent =
        (rawList != null && rawList is List)
            ? rawList.map((item) => ExpenseModel.fromJson(item)).toList()
            : [];

    return DashboardModel(
      totalIncome: ((json["totalIncome"] ?? 0) as num).toDouble(),
      totalExpense: ((json["totalExpense"] ?? 0) as num).toDouble(),
      netBalance: ((json["netBalance"] ?? 0) as num).toDouble(),
      recentExpenses: recent,
    );
  }
}
