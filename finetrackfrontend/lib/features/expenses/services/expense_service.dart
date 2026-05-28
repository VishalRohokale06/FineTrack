import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final Dio dio = ApiClient().dio;

  Future<List<ExpenseModel>> getExpenses() async {
    try {
      final response = await dio.get("/api/expenses");

      return (response.data as List)
          .map((item) => ExpenseModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch expenses");
    }
  }

  Future<ExpenseModel> getExpenseById(int id) async {
    try {
      final response = await dio.get("/api/expenses/$id");
      return ExpenseModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to fetch expense");
    }
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    required String paymentMethod,
    required String notes,
  }) async {
    try {
      await dio.post(
        "/api/expenses",
        data: {
          "title": title,
          "amount": amount,
          "category": category,
          "paymentMethod": paymentMethod,
          "notes": notes,
        },
      );
    } catch (e) {
      throw Exception("Failed to add expense");
    }
  }

  Future<void> updateExpense({
    required int id,
    required String title,
    required double amount,
    required String category,
    required String paymentMethod,
    required String notes,
  }) async {
    try {
      await dio.put(
        "/api/expenses/$id",
        data: {
          "title": title,
          "amount": amount,
          "category": category,
          "paymentMethod": paymentMethod,
          "notes": notes,
        },
      );
    } catch (e) {
      throw Exception("Failed to update expense");
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await dio.delete("/api/expenses/$id");
    } catch (e) {
      throw Exception("Failed to delete expense");
    }
  }
}
