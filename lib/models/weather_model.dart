import 'package:dart_casing/dart_casing.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.getData(Map<String, dynamic> data) {
    return Weather(
        cityName: data['name'],
        temperature: data['main']['temp'].toDouble(),
        mainCondition: Casing.titleCase(data['weather'][0]['description']));
  }
}
