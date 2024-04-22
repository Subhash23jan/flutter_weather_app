import 'dart:convert';
import 'dart:io';

class WeatherData {
  String description;
  double temperature;
  double pressure;
  double temperatureFeelsLike;
  double tempMax;
  double tempMin;
  double humidity;
  String city;
  double visibility;
  double windSpeed;
  DateTime sunset;
  DateTime sunrise;

  WeatherData({
    required this.temperatureFeelsLike,
    required this.description,
    required this.temperature,
    required this.pressure,
    required this.tempMax,
    required this.tempMin,
    required this.humidity,
    required this.visibility,
    required this.windSpeed,
    required this.sunset,
    required this.city,
    required this.sunrise,}
  );

  factory WeatherData.fromJson(Map<String, dynamic> parsed) {
    return WeatherData(
      description: parsed['weather'][0]['description'],
      temperature: parsed['main']['temp'].toDouble(),
      pressure: parsed['main']['pressure'].toDouble(),
      tempMax: parsed['main']['temp_max'].toDouble(),
      temperatureFeelsLike: parsed['main']['feels_like'].toDouble(),
      tempMin: parsed['main']['temp_min'].toDouble(),
      humidity: parsed['main']['humidity'].toDouble(),
      visibility: parsed['visibility'].toDouble(),
      windSpeed: parsed['wind']['speed'].toDouble(),
      city:parsed['name'],
      sunset: DateTime.fromMillisecondsSinceEpoch(parsed['sys']['sunset'] * 1000),
      sunrise: DateTime.fromMillisecondsSinceEpoch(parsed['sys']['sunrise'] * 1000),
    );
  }

}