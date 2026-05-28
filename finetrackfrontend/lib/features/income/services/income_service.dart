import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/income_model.dart';

class IncomeService {
  final Dio dio = ApiClient().dio;

  Future<List<IncomeModel>> getIncome() async {
    final response = await dio.get("/api/income");

    return (response.data as List)
        .map((item) => IncomeModel.fromJson(item))
        .toList();
  }

  Future<void> addIncome({
    required String title,
    required double amount,
    required String category,
    required String paymentMethod,
    required String notes,
  }) async {
    await dio.post(
      "/api/income",
      data: {
        "title": title,
        "amount": amount,
        "category": category,
        "paymentMethod": paymentMethod,
        "notes": notes,
      },
    );
  }

  Future<void> deleteIncome(int id) async {
    await dio.delete("/api/income/$id");
  }
}
