class CategoryBreakdownModel {
  final String category;
  final double amount;

  CategoryBreakdownModel({required this.category, required this.amount});

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownModel(
      category: json["category"]?.toString() ?? "Unknown",
      amount: (json["amount"] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class AnalyticsModel {
  final double totalIncome;
  final double totalExpenses;
  final double netBalance;
  final List<CategoryBreakdownModel> categoryBreakdown;

  AnalyticsModel({
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
    required this.categoryBreakdown,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    // Backend returns: totalIncome, totalExpenses, netBalance, categoryBreakdown
    final rawList = json["categoryBreakdown"];
    final List<CategoryBreakdownModel> breakdown =
        (rawList != null && rawList is List)
            ? rawList
                .map((item) => CategoryBreakdownModel.fromJson(item))
                .toList()
            : [];

    return AnalyticsModel(
      totalIncome: (json["totalIncome"] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (json["totalExpenses"] as num?)?.toDouble() ?? 0.0,
      netBalance: (json["netBalance"] as num?)?.toDouble() ?? 0.0,
      categoryBreakdown: breakdown,
    );
  }
}
