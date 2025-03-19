import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  static Future<NetworkException> fromDioException(DioException exception) async {
    // ✅ Check if there's no internet connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return NetworkException("📶 No internet connection. Please check your network.");
    }

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException("⏳ Network timeout. Please check your internet.");

      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode ?? 0;
        return NetworkException(_handleStatusCode(statusCode));

      case DioExceptionType.cancel:
        return NetworkException("🚫 Request cancelled.");

      case DioExceptionType.unknown:
        return NetworkException("⚠️ Unexpected error occurred. Try again later.");

      default:
        return NetworkException("❌ Something went wrong. Please try again.");
    }
  }

  static String _handleStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return "⚠️ Bad Request. Please check your input.";
      case 401:
        return "🔒 Unauthorized. Please check your API key.";
      case 403:
        return "🚫 Access Forbidden.";
      case 404:
        return "🔎 Not Found. Check the API URL.";
      case 500:
        return "🔥 Server Error. Try again later.";
      default:
        return "⚠️ Unknown error occurred.";
    }
  }

  @override
  String toString() => message;
}
