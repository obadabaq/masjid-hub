import 'dart:convert';

import 'package:http/http.dart' as http;

import '../secrets.dart';

class WeatherService {
  static Future<List<Map<String, dynamic>>> getWeather({
    required String lat,
    required String lon,
  }) async {
    final String baseUrl = "https://api.weatherapi.com/v1";
    final String days = "7";

    final url = Uri.parse(
        "$baseUrl/forecast.json?key=$weatherKey&q=$lat,$lon&days=$days&aqi=no&alerts=no");
    final response = await http.get(url);
    var data = json.decode(response.body);
    return data['forecast']['forecastday'] ?? [];
  }
}
