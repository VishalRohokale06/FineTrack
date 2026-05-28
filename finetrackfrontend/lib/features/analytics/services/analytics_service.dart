import 'package:dio/dio.dart';
import 'package:finetrack/core/network/api_client.dart';
import 'package:finetrack/features/analytics/models/ai_insight_model.dart';
import 'package:finetrack/features/analytics/models/analytics_model.dart';

class AnalyticsService {
  final Dio dio = ApiClient().dio;

  // Gets analytics for the CURRENT month/year automatically
  Future<AnalyticsModel> getAnalyticsData() async {
    final now = DateTime.now();
    return getMonthlyAnalytics(month: now.month, year: now.year);
  }

  Future<AnalyticsModel> getMonthlyAnalytics({
    required int month,
    required int year,
  }) async {
    try {
      final response = await dio.get(
        "/api/expenses/analytics",
        queryParameters: {"month": month, "year": year},
      );
      print("ANALYTICS RAW: ${response.data}");
      return AnalyticsModel.fromJson(response.data);
    } on DioException catch (e) {
      print("ANALYTICS DIO ERROR: ${e.message}");
      print("TYPE: ${e.type}");
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      throw Exception("Failed to load analytics: ${e.response?.statusCode}");
    } catch (e) {
      print("ANALYTICS PARSE ERROR: $e");
      throw Exception("Failed to parse analytics: $e");
    }
  }

  Future<AIInsightModel> getAIInsights({
    required int month,
    required int year,
  }) async {
    try {
      final response = await dio.get(
        "/api/expenses/ai-insights",
        queryParameters: {"month": month, "year": year},
      );
      return AIInsightModel.fromJson(response.data);
    } on DioException catch (e) {
      print("AI INSIGHTS ERROR: ${e.response?.statusCode} ${e.response?.data}");
      throw Exception("Failed to fetch AI insights");
    } catch (e) {
      throw Exception("Failed to parse AI insights: $e");
    }
  }
}
