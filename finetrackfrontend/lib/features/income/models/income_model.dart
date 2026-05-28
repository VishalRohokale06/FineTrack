class IncomeModel {
  final int id;
  final String title;
  final double amount;
  final String category;
  final String paymentMethod;
  final String notes;

  IncomeModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.paymentMethod,
    required this.notes,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json["id"],
      title: json["title"],
      amount: (json["amount"] as num).toDouble(),
      category: json["category"],
      paymentMethod: json["paymentMethod"],
      notes: json["notes"] ?? "",
    );
  }
}
