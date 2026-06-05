import 'package:dio/dio.dart';
import 'package:finetrack/core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 2),
        sendTimeout: const Duration(seconds: 30),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final pref = await SharedPreferences.getInstance();
          final token = pref.getString("jwt_token");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final pref = await SharedPreferences.getInstance();
            await pref.remove("jwt_token");
          }

          handler.next(e);
        },
      ),
    );
  }
}
