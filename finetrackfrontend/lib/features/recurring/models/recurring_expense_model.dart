class RecurringExpenseModel {
  final int id;
  final String title;
  final double amount;
  final String category;
  final String paymentMethod;
  final String frequency;
  final String nextDueDate;
  final bool active;

  RecurringExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.paymentMethod,
    required this.frequency,
    required this.nextDueDate,
    required this.active,
  });

  factory RecurringExpenseModel.fromJson(Map<String, dynamic> json) {
    return RecurringExpenseModel(
      id: json["id"],
      title: json["title"],
      amount: (json["amount"] as num).toDouble(),
      category: json["category"],
      paymentMethod: json["paymentMethod"],
      frequency: json["frequency"],
      nextDueDate: json["nextDueDate"],
      active: json["active"],
    );
  }
}
