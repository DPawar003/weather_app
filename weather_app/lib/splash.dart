import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/provider/weather_provider.dart';
import 'package:weather_app/features/weather/presentation/screens/weather_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    fetchWeatherAndNavigate();
  }

  void fetchWeatherAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate splash delay
    
    // ✅ Fetch weather data before navigating
    final weatherData = await ref.read(weatherProvider.future);
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(weather: weatherData),
        ),
      );
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
          ],
        ),
      ),
    );
  }
}
