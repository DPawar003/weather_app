import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/data/model/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherWidget extends StatelessWidget {
  final WeatherModel weather;

  const WeatherWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    // Format sunrise and sunset times
    final sunrise = DateTime.fromMillisecondsSinceEpoch(weather.sys.sunrise * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(weather.sys.sunset * 1000);
    final timeFormatter = DateFormat('HH:mm');
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar with location
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.white, size: 30),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Text(
                      weather.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.location_on, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
          
          // Current Temperature
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${weather.main.temp.round()}",
                          style: const TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "°",
                          style: TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${weather.main.tempMax.round()}° / ${weather.main.tempMin.round()}°",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      capitalizeFirstLetter(weather.weather[0].description),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Feels like ${weather.main.feelsLike.round()}°",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                _getWeatherIcon(weather.weather[0].main),
              ],
            ),
          ),
          
          // Weather forecast section
          Container(
  margin: const EdgeInsets.all(16),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color.fromRGBO(30, 136, 229, 0.4), // Equivalent to blue[500] with opacity
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Partly ${weather.weather[0].description}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        "Highs: ${weather.main.tempMax.round()}°",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      Text(
        "Lows: ${weather.main.tempMin.round()}°",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 16),

            // Rest of the container content
          ],
        ),
      ),
  
          
          // Location and AQI row
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                   color: Color.fromRGBO(30, 136, 229, 0.4), // Equivalent to blue[500] with opacity
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "Location",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${weather.name}, ${weather.sys.country}",
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "Lat: ${weather.coord.lat}, Lon: ${weather.coord.lon}",
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(30, 136, 229, 0.4), // Equivalent to blue[500] with opacity
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.air_outlined, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "AQI",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Visibility: ${(weather.visibility != null ? (weather.visibility! / 1000).toStringAsFixed(1) : 'N/A')} km",
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (weather.visibility != null ? weather.visibility! / 10000 : 0),
                            backgroundColor: Color.fromRGBO(244, 246, 248, 0.3), // Equivalent to blue[500] with opacity

                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Sunrise/Sunset Info
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(30, 136, 229, 0.4), // Equivalent to blue[500] with opacity,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sunrise",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          timeFormatter.format(sunrise),
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Icon(Icons.wb_sunny, color: Colors.white, size: 30),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white30),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sunset",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          timeFormatter.format(sunset),
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Icon(Icons.wb_twilight, color: Colors.amber, size: 30),
                  ],
                ),
              ],
            ),
          ),
          
          Row(
            children: [
              _buildInfoTile(
                "UV index", 
                "Moderate", 
                const Icon(Icons.sunny, color: Colors.white)
              ),
              _buildInfoTile(
                "Humidity", 
                "${weather.main.humidity}%", 
                const Icon(Icons.water_drop_outlined, color: Colors.tealAccent)
              ),
            ],
          ),
          
          Row(
            children: [
              _buildInfoTile(
                "Wind", 
                "${weather.wind.speed} m/s", 
                const Icon(Icons.air, color: Colors.white)
              ),
              _buildInfoTile(
                "Wind Direction", 
                "${weather.wind.deg}°", 
                const Icon(Icons.explore, color: Colors.white)
              ),
            ],
          ),
          
          Row(
            children: [
              _buildInfoTile(
                "Pressure", 
                "${weather.main.pressure} hPa", 
                const Icon(Icons.speed, color: Colors.white)
              ),
              _buildInfoTile(
                "Cloudiness", 
                "${weather.clouds.all}%", 
                const Icon(Icons.cloud, color: Colors.white)
              ),
            ],
          ),
        ],
      ),
        );
  }
  }
  
 Widget _buildInfoTile(String title, String value, Icon icon) {
  return SizedBox(
    width: 180, // Set a fixed width to prevent overflow
    child: Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
       color: Color.fromRGBO(30, 136, 229, 0.4), // Equivalent to blue[500] with opacity,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 8),
              Expanded( // Ensures the text doesn't exceed width
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

  
  Widget _getWeatherIcon(String condition) {
    double size = 80;
    IconData iconData = Icons.cloud;
    
    switch (condition.toLowerCase()) {
      case 'clear':
        iconData = Icons.wb_sunny;
        break;
      case 'clouds':
        iconData = Icons.cloud;
        break;
      case 'rain':
        iconData = Icons.grain;
        break;
      case 'thunderstorm':
        iconData = Icons.flash_on;
        break;
      case 'snow':
        iconData = Icons.ac_unit;
        break;
      case 'mist':
      case 'fog':
      case 'haze':
        iconData = Icons.cloud_queue;
        break;
      default:
        iconData = Icons.cloud;
    }
    
    return Icon(iconData, color: Colors.white, size: size);
  }
  
  
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
