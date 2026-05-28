import 'package:dio/dio.dart';
import 'package:finetrack/core/network/api_client.dart';
import 'package:finetrack/features/budgets/models/budget_model.dart';

class BudgetService {
  final Dio dio = ApiClient().dio;

  Future<List<BudgetModel>> getBudgets() async {
    try {
      final response = await dio.get("/api/budgets");

      return (response.data as List)
          .map((item) => BudgetModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch budgets");
    }
  }

  Future<List<BudgetAlertModel>> getAlerts() async {
    try {
      final response = await dio.get("/api/budgets/alerts");

      return (response.data as List)
          .map((item) => BudgetAlertModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch alerts");
    }
  }

  Future<void> createBudget({
    required String category,
    required double limitAmount,
  }) async {
    try {
      await dio.post(
        "/api/budgets",
        data: {"category": category, "limitAmount": limitAmount},
      );
    } catch (e) {
      throw Exception("Failed to create budget");
    }
  }

  Future<BudgetSummaryModel> getSummary() async {
    try {
      final response = await dio.get("/api/budgets/summary");
      return BudgetSummaryModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to fetch summary");
    }
  }
}
