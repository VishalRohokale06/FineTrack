import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    // return 'http://192.168.1.7:8080';
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080'; // ← EMULATOR
    }
    if (Platform.isIOS) {
      return 'http://localhost:8080';
    }
    return 'http://localhost:8080';
  }
}
