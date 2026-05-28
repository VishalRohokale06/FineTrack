class BudgetModel {
  final int id;
  final String category;
  final double limitAmount;
  final double spentAmount;

  BudgetModel({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.spentAmount,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json["id"],
      category: json["category"],
      limitAmount: (json["limitAmount"] as num).toDouble(),
      spentAmount: (json["spentAmount"] as num).toDouble(),
    );
  }
}

class BudgetAlertModel {
  final String category;
  final double budgetLimit;
  final double spentAmount;
  final String message;

  BudgetAlertModel({
    required this.category,
    required this.budgetLimit,
    required this.spentAmount,
    required this.message,
  });

  factory BudgetAlertModel.fromJson(Map<String, dynamic> json) {
    return BudgetAlertModel(
      category: json["category"],
      budgetLimit: (json["budgetLimit"] as num).toDouble(),
      spentAmount: (json["spentAmount"] as num).toDouble(),
      message: json["message"],
    );
  }
}

class BudgetSummaryModel {
  final double totalBudget;
  final double totalSpent;
  final double remainingAmount;

  BudgetSummaryModel({
    required this.totalBudget,
    required this.totalSpent,
    required this.remainingAmount,
  });

  factory BudgetSummaryModel.fromJson(Map<String, dynamic> json) {
    return BudgetSummaryModel(
      totalBudget: (json["totalBudget"] as num).toDouble(),
      totalSpent: (json["totalSpent"] as num).toDouble(),
      remainingAmount: (json["remainingAmount"] as num).toDouble(),
    );
  }
}
