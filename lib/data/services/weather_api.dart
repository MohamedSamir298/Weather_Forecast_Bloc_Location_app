import 'package:dio/dio.dart' as http;
import '../../constants/strings.dart';
import '../model/weather_data_model.dart';
import '../model/weather_forecast_model.dart';

class WeatherApi {

  Future<WeatherData> fetchWeather(String city) async {
    var url = "$baseUrl?q=$city&appid=$apiKey&units=metric";
    var response = await http.Dio().get(url);
    if (response.statusCode == 200) {
      return WeatherData.fromJson(response.data);
    } else {
      throw Exception('Failed to load Location');
    }
  }

  Future<WeatherData> fetchWeatherByCoordinates(double latitude, double longitude) async {
    final response = await http.Dio().get('$baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
    if (response.statusCode == 200) {
      return WeatherData.fromJson(response.data);
    } else {
      throw Exception('Failed to load Location');
    }
  }

  Future<Weather5daysModel> fetchWeatherForecast5DaysByCoordinates(double latitude, double longitude) async {
    final response = await http.Dio().get('$baseUrlForcast5Days?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
    if (response.statusCode == 200) {
      return Weather5daysModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load 5 Days Location');
    }
  }

}
