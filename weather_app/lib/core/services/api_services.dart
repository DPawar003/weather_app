import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weather_app/features/weather/data/model/weather_model.dart';

part 'api_services.g.dart';  // ✅ Required for Retrofit code generation

// ✅ Define ApiService with Retrofit
@RestApi(baseUrl: "https://api.openweathermap.org/data/2.5/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("weather")
  Future<WeatherModel> getWeather(
    @Query("lat") double latitude,
    @Query("lon") double longitude,
    @Query("appid") String apiKey,
    @Query("units") String units, // "metric" for Celsius
  );
}

// ✅ Create a Riverpod provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = Dio();
  return ApiService(dio);
});
