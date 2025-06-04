import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:masjidhub/provider/wathc_provider.dart';
class QiblaHelper {
  static const String apiKey = 'zNEw7'; // Replace with your actual API key
  static const double _meccaLat = 21.4225; // Mecca Latitude as double
  static const double _meccaLon = 39.8262; // Mecca Longitude as double

  // Calculates the Qibla angle based on the user's location
  static double calculateQiblaAngle(double userLat, double userLon) {
    double lat1 = userLat * pi / 180.0;
    double lon1 = userLon * pi / 180.0;
    double lat2 = _meccaLat * pi / 180.0;
    double lon2 = _meccaLon * pi / 180.0;

    double deltaLon = lon2 - lon1;
    double x = cos(lat2) * sin(deltaLon);
    double y = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon);

    double qiblaAngle = atan2(x, y) * 180.0 / pi; // Convert to degrees
    return (qiblaAngle + 360) % 360; // Normalize angle to 0-360 degrees
  }

  // Gets magnetic declination angle from an external API
  static Future<double> getDeclinationAngle(double userLat, double userLon) async {
    try {
      final url = Uri.parse(
          'https://www.ngdc.noaa.gov/geomag-web/calculators/calculateDeclination?lat1=$userLat&lon1=$userLon&resultFormat=json&key=$apiKey');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['result'][0]['declination']; // Adjust as per response format
      } else {
        throw Exception('Failed to fetch declination angle');
      }
    } catch (e) {
      print('Error fetching declination angle: $e');
      rethrow; // Re-throw the error to handle it outside
    }
  }

  // Sends command to watch based on calculated Qibla and declination angles
  static Future<void> sendQiblaCommand(double userLat, double userLon, WatchProvider watchProvider) async {
    try {
      // Calculate Qibla and declination angles
      double qiblaAngle = calculateQiblaAngle(userLat, userLon);
      double declinationAngle = await getDeclinationAngle(userLat, userLon);

      // Convert Qibla angle to a 4-bit hexadecimal string
      String hexQiblaAngle = qiblaAngle.round().toRadixString(16).padLeft(4, '0').toUpperCase();

      // Convert declination angle to a 2-digit hexadecimal string
      String hexDeclinationAngle = declinationAngle.round().toRadixString(16).padLeft(2, '0').toUpperCase();

      // Concatenate the command as a single hex string
      String hexCommand = '1A01F6${hexQiblaAngle}${hexDeclinationAngle}00';

      // Debugging logs
      print('Qibla Angle (Degrees): $qiblaAngle');
      print('Qibla Angle (Hex): $hexQiblaAngle');
      print('Declination Angle (Degrees): $declinationAngle');
      print('Declination Angle (Hex): $hexDeclinationAngle');
      print('Final Hex Command: $hexCommand');

      // Send the command to the watch
      watchProvider.sendCommand(hexCommand);
      print('Qibla command sent successfully!');
    } catch (e) {
      print('Error in sendQiblaCommand: $e');
    }
  }

// Placeholder for actual Bluetooth command sending

}
