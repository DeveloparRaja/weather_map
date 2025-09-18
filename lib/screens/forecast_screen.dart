import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import 'package:intl/intl.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final forecast = provider.forecast;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: provider.isDarkMode ? Colors.grey.shade900 : Colors.blue.shade300,
        title: const Text(
          "5-Day Forecast",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              provider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
            onPressed: () => provider.toggleDarkMode(),
          ),
        ],
      ),

      body: Container(
        height: 800,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: provider.isDarkMode
                ? [Colors.grey.shade900, Colors.black]
                : [Colors.blue.shade300, Colors.blue.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: forecast.isEmpty
                  ? const Center(
                child: Text(
                  "No forecast data available",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: forecast.length,
                itemBuilder: (context, index) {
                  final day = forecast[index];
                  final formattedDate =
                  DateFormat('EEE, dd MMM').format(day.date);

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: provider.isDarkMode
                        ? Colors.grey.shade800
                        : Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://openweathermap.org/img/wn/${day.icon}@2x.png",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: provider.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        day.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: provider.isDarkMode
                              ? Colors.white70
                              : Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        "${day.temp.toStringAsFixed(1)}${provider.unitSymbol}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: provider.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
