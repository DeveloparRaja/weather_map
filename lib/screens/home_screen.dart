import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import 'forecast_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.weather;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: weatherProvider.isDarkMode
                ? [Colors.grey.shade900, Colors.black]
                : [Colors.blue.shade300, Colors.blue.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              if (weatherProvider.lastCity.isNotEmpty) {
                await weatherProvider.fetchWeather(weatherProvider.lastCity);
                await weatherProvider.fetchForecast();
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🔝 App Bar Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Weather App",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            tooltip: "Toggle Theme",
                            icon: Icon(
                              weatherProvider.isDarkMode
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: Colors.white,
                            ),
                            onPressed: () => weatherProvider.toggleDarkMode(),
                          ),
                          IconButton(
                            tooltip: "Toggle °C/°F",
                            icon: const Icon(Icons.swap_vert, color: Colors.white),
                            onPressed: () => weatherProvider.toggleUnit(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: TextField(
                      controller: _cityController,
                      onSubmitted: (value)async {
                          await weatherProvider
                              .fetchWeather(_cityController.text);
                          await weatherProvider.fetchForecast();

                      },
                      decoration: InputDecoration(
                        hintText: "Enter city",
                        prefixIcon: const Icon(Icons.location_city),
                        border: InputBorder.none,

                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            await weatherProvider
                                .fetchWeather(_cityController.text);
                            await weatherProvider.fetchForecast();
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ⏳ Loading / Error / Weather Info / Placeholder
                  if (weatherProvider.isLoading)
                    const CircularProgressIndicator(color: Colors.white)
                  else if (weatherProvider.error != null)
                    Text(
                      weatherProvider.error!,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    )
                  else if (weather != null)
                    // Weather card
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: weatherProvider.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                "${weather.cityName}, ${weather.country}",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: weatherProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Image.network(
                                "https://openweathermap.org/img/wn/${weather.icon}@4x.png",
                                width: 120,
                                height: 120,
                              ),
                              Text(
                                "${weather.temperature.toStringAsFixed(1)}${weatherProvider.unitSymbol}",
                                style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.bold,
                                  color: weatherProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              Text(
                                weather.description,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: weatherProvider.isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ForecastScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.calendar_today),
                                label: const Text("View 5-Day Forecast"),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                  backgroundColor: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                    // Placeholder when no city searched yet
                      Column(
                        children: const [
                          SizedBox(height: 50),
                          Icon(
                            Icons.cloud_queue,
                            size: 100,
                            color: Colors.white70,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Enter a city name above to see the weather",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
