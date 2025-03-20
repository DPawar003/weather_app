import 'package:weather_app/core/network/weather_api.dart';
import 'package:weather_app/core/utils/logger.dart';
import 'package:weather_app/core/services/location_services.dart';
import '../model/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/core/exception_handling/network_exceptions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WeatherRepository {
  final WeatherApi _api;
  final String _apiKey;

  WeatherRepository() : 
    _api = WeatherApi(Dio()),
    _apiKey = dotenv.env['API_KEY'] ?? '' {
    // Validate API key on initialization
    if (_apiKey.isEmpty) {
      AppLogger.error("❌ API Key is missing or empty. Please check your .env file.");
    }
  }

  Future<WeatherModel?> fetchWeather() async {
    // Validate API key
    if (_apiKey.isEmpty) {
      AppLogger.error("❌ API Key is missing or empty. Please check your .env file.");
      return null;
    }
    
    // Check for internet connection
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
        _apiKey,
        "metric",
      );
      return response;
    } on DioException catch (e) {
      final error = await NetworkException.fromDioException(e);
      AppLogger.error("❌ API Error: ${error.message}");
      
      // Check for API key issues
      if (e.response?.statusCode == 401) {
        AppLogger.error("❌ API Key unauthorized. Please check your API key.");
      }
      return null;
    } catch (e) {
      AppLogger.error("❌ Unexpected Error: $e");
      return null;
    }
  }
  
  Future<WeatherModel?> fetchWeatherByCity(String cityName) async {
    // Validate API key
    if (_apiKey.isEmpty) {
      AppLogger.error("❌ API Key is missing or empty. Please check your .env file.");
      return null;
    }
    
    // Check for internet connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      AppLogger.error("📶 No internet connection.");
      return null;
    }

    if (cityName.isEmpty) {
      AppLogger.error("❌ City name cannot be empty.");
      return null;
    }

    try {
      AppLogger.info("🔍 Fetching weather for city: $cityName");
      final response = await _api.getWeatherByCity(
        cityName,
        _apiKey,
        "metric",
      );
      return response;
    } on DioException catch (e) {
      final error = await NetworkException.fromDioException(e);
      AppLogger.error("❌ API Error: ${error.message}");
      
      // Check for API key issues
      if (e.response?.statusCode == 401) {
        AppLogger.error("❌ API Key unauthorized. Please check your API key.");
      }
      
      // Check for specific city not found error
      if (e.response?.statusCode == 404) {
        AppLogger.error("❌ City not found: $cityName");
      }
      
      return null;
    } catch (e) {
      AppLogger.error("❌ Unexpected Error: $e");
      return null;
    }
  }
}