import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/weather_model.dart';
import '../data/repository/weather_repository.dart';

// Create a repository provider
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository();
});

// State notifier for managing search term
class SearchTermNotifier extends StateNotifier<String> {
  SearchTermNotifier() : super('');
  
  void setSearchTerm(String term) {
    state = term;
  }
}

// Provider for the search term
final searchTermProvider = StateNotifierProvider<SearchTermNotifier, String>((ref) {
  return SearchTermNotifier();
});

// Provider that combines location-based and search-based weather results
final weatherProvider = FutureProvider<WeatherModel?>((ref) async {
  final repository = ref.watch(weatherRepositoryProvider);
  final searchTerm = ref.watch(searchTermProvider);
  
  if (searchTerm.isEmpty) {
    // Fetch weather based on current location
    return await repository.fetchWeather();
  } else {
    // Fetch weather based on city search
    return await repository.fetchWeatherByCity(searchTerm);
  }
});