import '../data/model/weather_forecast_model.dart';
import '../data/model/weather_data_model.dart';

abstract class WeatherStates{
  const WeatherStates();
}
class WeatherInitial extends WeatherStates {}
class Loading extends WeatherStates {}
class LoadedSuccessfully extends WeatherStates {
  final WeatherData weatherData;
  final Weather5daysModel weather5daysModel;
  const LoadedSuccessfully(this.weatherData, this.weather5daysModel);
}
class Error extends WeatherStates {
  final String message;
  const Error(this.message);
}

