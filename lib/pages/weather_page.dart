import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService("c7a06df523e9614d3dc03a8c648748c2");
  Weather? _weather;
  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWether(cityName);
      setState(() {
        _weather = weather;
      });
    }
    // any errors
    catch (e) {
      throw Exception(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return "assets/sunny.json";
    }
    switch (mainCondition.toLowerCase()) {
      case "clear":
        return "assets/sunny.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/rain.json";
      case "thunderstorm":
        return "assets/thunder.json";
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/cloud.json";
      default:
        return "assets/sunny.json";
    }
  }

  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.white,
                    ),
                    Text(_weather?.cityName.toUpperCase() ?? "Loading City..",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Text('${_weather?.temperature.round()}°',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.bold)),
              ),
              // Text(
              //   _weather?.mainCondition ?? "",
              //   style: const TextStyle(color: Colors.white),
              // ),
            ],
          ),
        ));
  }
}
