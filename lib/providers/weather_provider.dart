import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';

enum TemperatureUnit { celsius, fahrenheit }

class WeatherProvider with ChangeNotifier {
  final WeatherService _service = WeatherService();

  Weather? _weather;
  List<Forecast> _forecast = [];
  bool _isLoading = false;
  String? _error;
  String _lastCity = "";
  TemperatureUnit _unit = TemperatureUnit.celsius;
  bool _isDarkMode = false;

  Weather? get weather => _weather;
  List<Forecast> get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get lastCity => _lastCity;
  TemperatureUnit get unit => _unit;
  bool get isDarkMode => _isDarkMode;

  WeatherProvider() {
    _loadPrefsAndInitial();
  }

  String get unitString => _unit == TemperatureUnit.celsius ? 'metric' : 'imperial';
  String get unitSymbol => _unit == TemperatureUnit.celsius ? '°C' : '°F';

  Future<void> _loadPrefsAndInitial() async {
    final prefs = await SharedPreferences.getInstance();
    _lastCity = prefs.getString('last_city') ?? "";
    final u = prefs.getString('temp_unit') ?? 'c';
    _unit = u == 'c' ? TemperatureUnit.celsius : TemperatureUnit.fahrenheit;
    _isDarkMode = prefs.getBool('dark_mode') ?? false;

    if (_lastCity.isNotEmpty) {
      await fetchWeather(_lastCity);
      await fetchForecast();
    }
  }

  Future<void> fetchWeather(String city) async {
    if (city.trim().isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final w = await _service.fetchWeatherByCity(city, units: unitString);
      _weather = w;
      _lastCity = city;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_city', city);
    } catch (e) {
      _error = 'City not found';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchForecast() async {
    if (_lastCity.isEmpty) return;
    try {
      final f = await _service.fetchForecast(_lastCity, units: unitString);
      _forecast = f;
    } catch (e) {
      _error = 'Unable to load forecast';
    } finally {
      notifyListeners();
    }
  }

  Future<void> toggleUnit() async {
    _unit = _unit == TemperatureUnit.celsius
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('temp_unit', _unit == TemperatureUnit.celsius ? 'c' : 'f');

    if (_lastCity.isNotEmpty) {
      await fetchWeather(_lastCity);
      await fetchForecast();
    } else {
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
