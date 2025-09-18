import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  static const String apiKey = "0e3b9b6d1eb15d7e2e84da8403ab426b";

  Future<Weather> fetchWeatherByCity(String city, {String units = 'metric'}) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=$units"
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('City not found');
    }
  }

  Future<List<Forecast>> fetchForecast(String city, {String units = 'metric'}) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=$units",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['list'];

      final daily = list.where((e) {
        final time = DateTime.parse(e['dt_txt']);
        return time.hour == 12;
      }).toList();

      return daily.map((e) => Forecast.fromJson(e)).toList();
    } else {
      throw Exception('Unable to fetch forecast');
    }
  }
}
