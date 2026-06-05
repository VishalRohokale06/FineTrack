import 'package:dio/dio.dart';
import 'package:finetrack/core/network/api_client.dart';

class ChatService {
  final Dio dio = ApiClient().dio;

  Future<String> sendMessage(String message) async {
    final response = await dio.post("/api/chat", data: {"message": message});

    return response.data["response"];
  }
}
