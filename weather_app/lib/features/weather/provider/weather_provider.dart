import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/weather_model.dart';
import '../data/repository/weather_repository.dart';

final weatherProvider = FutureProvider<WeatherModel?>((ref) async {
  return await WeatherRepository().fetchWeather();
});
