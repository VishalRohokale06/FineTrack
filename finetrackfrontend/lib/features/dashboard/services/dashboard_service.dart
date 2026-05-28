import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  final Dio dio = ApiClient().dio;

  Future<DashboardModel> getDashboardData() async {
    try {
      final response = await dio.get("/api/expenses/dashboard");

      print("DASHBOARD RESPONSE: ${response.data}");

      return DashboardModel.fromJson(response.data);
    } catch (e) {
      print("DASHBOARD ERROR: $e");
      rethrow;
    }
  }
}
