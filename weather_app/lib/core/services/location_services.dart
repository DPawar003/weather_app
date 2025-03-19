import 'package:geolocator/geolocator.dart';
import '../utils/logger.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    try {
      // ✅ Step 1: Check if Location Service is Enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppLogger.error("❌ Location services are disabled. Please enable GPS.");
        return null;
      }

      // ✅ Step 2: Check Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        AppLogger.error("📢 Requesting location permission...");
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppLogger.error("❌ Location permission denied by user.");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppLogger.error("❌ Location permission permanently denied. Enable it from settings.");
        return null;
      }

      // ✅ Step 3: Get Current Location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      AppLogger.info("📍 Location Retrieved: ${position.latitude}, ${position.longitude}");
      return position;
    } catch (e) {
      AppLogger.error("❌ Error getting location: $e");
      return null;
    }
  }
}
