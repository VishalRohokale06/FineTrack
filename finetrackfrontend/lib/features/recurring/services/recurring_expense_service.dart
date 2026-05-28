import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/recurring_expense_model.dart';

class RecurringExpenseService {
  final Dio dio = ApiClient().dio;

  Future<List<RecurringExpenseModel>> getRecurringExpenses() async {
    final response = await dio.get("/api/recurring-expenses");

    return (response.data as List)
        .map((item) => RecurringExpenseModel.fromJson(item))
        .toList();
  }

  Future<void> createRecurringExpense({
    required String title,
    required double amount,
    required String category,
    required String paymentMethod,
    required String frequency,
  }) async {
    await dio.post(
      "/api/recurring-expenses",
      data: {
        "title": title,
        "amount": amount,
        "category": category,
        "paymentMethod": paymentMethod,
        "frequency": frequency,
      },
    );
  }

  Future<void> deleteRecurringExpense(int id) async {
    await dio.delete("/api/recurring-expenses/$id");
  }
}
