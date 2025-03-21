import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/data/model/weather_model.dart';
import '../widget/weather_card.dart';
import '../widget/search_widget.dart';

class WeatherScreen extends StatelessWidget {
  final WeatherModel? weather;

  const WeatherScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: SafeArea(
        child: Column(
          children: [
            // Add search bar at the top
            Consumer(
              builder: (context, ref, child) {
                return const WeatherSearchBar();
              },
            ),
            
            // Weather content
            Expanded(
              child: weather == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 50),
                        const Text(
                          "Failed to fetch weather. Check API key & permissions.",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: WeatherWidget(weather: weather!),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}