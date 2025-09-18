class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final String description;
  final String icon;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      country: json['sys']['country'],
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
