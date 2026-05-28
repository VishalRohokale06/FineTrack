class ExpenseModel {
  final int id;
  final String title;
  final double amount;
  final String category;
  final String paymentMethod;
  final String notes;
  final String createdAt;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.paymentMethod,
    required this.notes,
    required this.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json["id"],
      title: json["title"],
      amount: (json["amount"] as num).toDouble(),
      category: json["category"],
      paymentMethod: json["paymentMethod"],
      notes: json["notes"] ?? "",
      createdAt: json["createdAt"],
    );
  }
}
