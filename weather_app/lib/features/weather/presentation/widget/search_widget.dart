import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/presentation/screens/weather_screen.dart';
import 'package:weather_app/features/weather/provider/weather_provider.dart';

class WeatherSearchBar extends ConsumerStatefulWidget {
  const WeatherSearchBar({Key? key}) : super(key: key);

  @override
  ConsumerState<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends ConsumerState<WeatherSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  String? _errorMessage; // State for error message

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Solid white background
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search city...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.blue),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _errorMessage = null; // Clear error when reset
                    });
                    _refreshWeatherWithLocation();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchByCity(value);
                }
              },
            ),
          ),

          // Error message displayed outside the search bar
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ],

          const SizedBox(height: 8),

          Consumer(
            builder: (context, ref, child) {
              final searchTerm = ref.watch(searchTermProvider);
              if (searchTerm.isNotEmpty) {
                return GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _refreshWeatherWithLocation();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.my_location, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Use my location',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  void _searchByCity(String cityName) async {
    try {
      ref.read(searchTermProvider.notifier).setSearchTerm(cityName);

      final weatherData = await ref.read(weatherProvider.future);

      if (weatherData == null) {
        setState(() {
          _errorMessage = "City not found. Try again.";
        });
        return;
      }

      setState(() {
        _errorMessage = null;
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherScreen(weather: weatherData),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = "City not found. Try again.";
      });
    }
  }

  void _refreshWeatherWithLocation() async {
    ref.read(searchTermProvider.notifier).setSearchTerm('');

    final weatherData = await ref.read(weatherProvider.future);

    setState(() {
      _errorMessage = null;
    });

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(weather: weatherData),
        ),
      );
    }
  }
}
