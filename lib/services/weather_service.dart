import 'dart:convert';

import 'package:agibu/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class WeatherService {
  static const BASEURL = "https://api.openweathermap.org/data/2.5/weather";
  final String apikey;

  WeatherService(this.apikey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
        Uri.parse('$BASEURL?q=$cityName&appid=$apikey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location service is disabled.");
        return "Unknown Location";
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permission denied.");
          return "Unknown Location";
        }
      }

      // Ambil lokasi
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Konversi ke alamat
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      String? city = placemarks.isNotEmpty
          ? placemarks[0].subAdministrativeArea // Ambil kota, bukan kecamatan
          : null;

      print("Detected city: $city");
      return city ?? "Jakarta"; // Default ke Jakarta jika tidak ditemukan
    } catch (e) {
      print("Error fetching location: $e");
      return "Jakarta"; // Default ke Jakarta jika gagal
    }
  }
}