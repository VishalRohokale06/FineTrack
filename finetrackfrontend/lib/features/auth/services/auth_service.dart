import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';

class AuthService {
  final Dio dio = ApiClient().dio;

  Future<String> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        "/api/auth/register",
        data: {"fullName": fullName, "email": email, "password": password},
      );

      print("SUCCESS STATUS: ${response.statusCode}");
      print("SUCCESS DATA: ${response.data}");

      return response.data["message"];
    } on DioException catch (e) {
      print("ERROR STATUS: ${e.response?.statusCode}");
      print("ERROR DATA: ${e.response?.data}");
      print("ERROR MESSAGE: ${e.message}");

      throw Exception(e.response?.data.toString());
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        "/api/auth/login",
        data: {"email": email, "password": password},
      );

      print("STATUS: ${response.statusCode}");
      print("DATA: ${response.data}");

      final token = response.data["token"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("jwt_token", token);

      await prefs.setString("user_name", email.split("@").first);
      print("SAVED NAME: ${prefs.getString("user_name")}");

      await prefs.setString("user_email", email);

      return token;
    } on DioException catch (e) {
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      print("ERROR: ${e.message}");

      throw Exception(e.response?.data.toString());
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt_token");
  }
}
