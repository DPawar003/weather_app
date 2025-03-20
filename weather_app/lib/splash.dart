import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/provider/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/screens/weather_screen.dart';
import 'package:weather_app/core/utils/logger.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchWeatherAndNavigate();
  }

  void fetchWeatherAndNavigate() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate splash delay
      
      // Reset any previous search term when app starts
      ref.read(searchTermProvider.notifier).setSearchTerm('');
      
      // Fetch weather data before navigating
      final weatherData = await ref.read(weatherProvider.future);
      
      if (!mounted) return;
      
      // Navigate to weather screen with the data (even if null)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(weather: weatherData),
        ),
      );
    } catch (e) {
      AppLogger.error("❌ Error in splash screen: $e");
      
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to initialize app. Please check your internet connection and try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 200),
            const SizedBox(height: 20),
            const Text(
              "Weather App",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 108, 218)),
            ),
            const SizedBox(height: 30),
            if (_isLoading)
              const CircularProgressIndicator(color: Color.fromARGB(255, 5, 108, 218))
            else if (_errorMessage != null)
              Column(
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                      fetchWeatherAndNavigate();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}