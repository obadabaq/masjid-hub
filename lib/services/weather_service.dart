import 'dart:convert';

import 'package:http/http.dart' as http;

import '../secrets.dart';

class WeatherService {
  static Future<List<Map<String, dynamic>>> getWeather({
    required String lat,
    required String lon,
  }) async {
    try {
      final String baseUrl = "https://api.weatherapi.com/v1";
      final String days = "7";

      final url = Uri.parse(
          "$baseUrl/forecast.json?key=$weatherKey&q=$lat,$lon&days=$days&aqi=no&alerts=no");
      final response = await http.get(url);
      var data = jsonDecode(response.body);
      List items = data['forecast']['forecastday'] as List<dynamic>;
      var d = items.map((item) => item as Map<String, dynamic>).toList();
      return d;
    } catch (e) {
      return [];
    }
  }
}
