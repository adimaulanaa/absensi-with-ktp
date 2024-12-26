import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> isGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  static Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        distanceFilter: 100,
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  static Future<double> isLatitude() async {
    bool isGps = await isGpsEnabled();
    bool isPermission = await requestPermission();
    double latitude = -1.003189; // Default latitude
    if (isGps && isPermission) {
      Position position = await LocationService.getCurrentLocation();
      latitude = position.latitude;
    }
    return latitude;
  }

  static Future<double> isLongitude() async {
    bool isGps = await isGpsEnabled();
    bool isPermission = await requestPermission();
    double longitude = 101.972332; // Default longitude
    if (isGps && isPermission) {
      Position position = await LocationService.getCurrentLocation();
      longitude = position.longitude;
    }
    return longitude;
  }
}
