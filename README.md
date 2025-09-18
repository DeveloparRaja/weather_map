🌦 Flutter Weather App – Setup Guide  

1️. Project Clone:  
github link :-  https://github.com/DeveloparRaja/weather_map  

2️. Install Dependencies:  
flutter pub get  

3️. API Key Setup:  
• OpenWeatherMap par free account banye hai → https://home.openweathermap.org/api_keys  
• API key copy karo aur lib/Service/WeatherService.dart me "0e3b9b6d1eb15d7e2e84da8403ab426b" replace kiye hai 

4️. App Run:  
flutter run  

5. APK ready hai: build/app/outputs/flutter-apk/app-release.apk  



6.Project Overview :-
Ye ek simple Weather App hai jo OpenWeatherMap API se real-time weather data fetch kiya gaya  hai.
Features:
1. City search (current weather + location name)
2. 5-Day Forecast screen
3. Weather icons (sunny, cloudy, rainy, etc.)
4. Dark mode toggle
5. Celsius / Fahrenheit toggle
6. Pull-to-refresh
7. Last searched city locally save (SharedPreferences)

7.Tech Stack :-
Flutter (Dart)
Provider (State Management)
SharedPreferences (Local Storage)
HTTP Package (API Calls)
OpenWeatherMap API
