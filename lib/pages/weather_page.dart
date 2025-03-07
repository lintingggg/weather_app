import 'package:agibu/models/weather_model.dart';
import 'package:agibu/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('5541a757fba593f8209b46d665c640b6');
  Weather? _weather;
  final TextEditingController _cityController = TextEditingController();

  // Fetch Weather berdasarkan input user
  _fetchWeather(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Error fetching weather: $e");
      setState(() {
        _weather = null; // Jika gagal, set ke null
      });
    }
  }

  // Weather Animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'shower rain':
        return 'assets/rian.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextField untuk input nama kota
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: "Masukkan nama kota...",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_cityController.text.isNotEmpty) {
                      _fetchWeather(_cityController.text);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // City Name
            Text(
              _weather?.cityName ?? "Masukkan kota untuk mencari cuaca",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Weather Animation
            _weather != null
                ? Lottie.asset(getWeatherAnimation(_weather?.mainCondition))
                : Container(height: 150), // Placeholder jika belum ada data

            const SizedBox(height: 10),

            // Temperature
            Text(
              _weather?.temperature?.round()?.toString() ?? "--",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),

            // Condition
            Text(
              _weather?.mainCondition ?? "",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
