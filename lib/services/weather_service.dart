import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;
  //c7a06df523e9614d3dc03a8c648748c2
  WeatherService(this.apiKey);

  Future<Weather> getWether(String cityName) async {
    try {
      final response = await http
          .get(Uri.parse("$BASE_URL?q=$cityName&appid=$apiKey&units=metric"));
      if (response.statusCode == 200) {
        try {
          return Weather.fromJson(jsonDecode(response.body));
        } catch (e) {
          throw Exception("Error decoding weather data: $e");
        }
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      throw Exception("Error fetching weather data: $e");
    }
  }

  Future<String> getCurrentCity() async {
    try {
      // get permission from user
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // can't get permission
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission is permanently denied");
      }

      // fetch the current location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 100),
      );

      // convert the location into a list of placemark objects
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // extract the city name from the first placemark
      String? city = placemarks[0].locality;
      return city ?? "";
    } catch (e) {
      throw Exception("Error fetching current city: $e");
    }
  }
}
