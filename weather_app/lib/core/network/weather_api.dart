import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../features/weather/data/model/weather_model.dart';

part 'weather_api.g.dart';

@RestApi(baseUrl: "https://api.openweathermap.org/data/2.5/")
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  @GET("weather")
  Future<WeatherModel> getWeather(
    @Query("lat") double lat,
    @Query("lon") double lon,
    @Query("appid") String apiKey,
    @Query("units") String units,
  );
}
