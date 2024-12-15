import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _weather;
  DateTime? _now;
  final TextEditingController _controller = TextEditingController();

  void _fetchWeather(String cityName) async {
    final weather = await WeatherService(cityName);
    try {
      setState(() {
        _weather = weather;
        _now = DateTime.now();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather('Manila'); // Default city
  }

  String getWeatherAnimation(String mainCondition) {
    final description = mainCondition.toLowerCase();
    if (description.contains('rain') || description.contains('drizzle')) {
      return 'assets/rainy.json';
    } else if (description.contains('clouds')) {
      return 'assets/cloudy.json';
    } else if (description.contains('thunderstorm')) {
      return 'assets/thunder.json';
    } else if (description.contains('snow')) {
      return 'assets/snow.json';
    } else {
      return 'assets/sunny.json';
    }
  }

  String checkSuspension(String mainCondition) {
    final description = mainCondition.toLowerCase();
    if (description.contains('heavy') || description.contains('extreme')) {
      return 'Suspended';
    } else {
      return 'No announcements ️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 160,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search city...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _fetchWeather(_controller.text);
                      _controller.text = "";
                    },
                  ),
                ],
              ),
            ),
            Text(
              '${_weather?.temperature.round()}°C',
              style: const TextStyle(fontSize: 60),
            ),
            Lottie.asset(getWeatherAnimation(
                _weather?.mainCondition ?? "assets/sunny.json")),
            const SizedBox(
              height: 16,
            ),
            Text(
              _weather?.mainCondition ?? "",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              _weather?.cityName ?? "",
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("// Johann.dev"),
          ],
        ),
      ),
    );
  }
}
