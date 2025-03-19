import 'package:weather_app/core/network/weather_api.dart';
import 'package:weather_app/core/utils/logger.dart';
import 'package:weather_app/core/services/location_services.dart';
import '../model/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/core/exception_handling/network_exceptions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WeatherRepository {
  final WeatherApi _api = WeatherApi(Dio());

  Future<WeatherModel?> fetchWeather() async {
    // ✅ Check for internet connection before making API call
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      AppLogger.error("📶 No internet connection.");
      return null;
    }

    final position = await LocationService.getCurrentLocation();
    if (position == null) {
      AppLogger.error("❌ Failed to get location.");
      return null;
    }

    try {
      AppLogger.info("📍 Fetching weather for: ${position.latitude}, ${position.longitude}");
      final response = await _api.getWeather(
        position.latitude,
        position.longitude,
        dotenv.env['API_KEY']!,
        "metric",
      );
      return response;
    } on DioException catch (e) {
      final error = await NetworkException.fromDioException(e);
      AppLogger.error(error.message);
      return null;
    } catch (e) {
      AppLogger.error("❌ Unexpected Error: $e");
      return null;
    }
  }
}
