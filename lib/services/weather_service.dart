import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

Future<Weather> WeatherService(String cityName) async {
  String apiKey = "c8b477055da4120916f09ed3de019c06";
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return Weather.getData(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load weather data");
  }
}
