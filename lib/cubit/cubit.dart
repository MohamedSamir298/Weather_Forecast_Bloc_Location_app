import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:weather_bloc_5days_location_app/cubit/states.dart';
import '../data/model/weather_forecast_model.dart';
import '../data/model/weather_data_model.dart';
import '../data/services/weather_api.dart';

class WeatherCubit extends Cubit<WeatherStates> {
  final WeatherApi weatherApi;
  WeatherCubit(this.weatherApi) : super(WeatherInitial());
  static WeatherCubit get(context) => BlocProvider.of(context);

  late WeatherData _currentWeather;
  late Weather5daysModel _weather5daysModel;
  bool isSearchOpen = false;
  WeatherData get currentWeather => _currentWeather;
  Weather5daysModel get weather5daysModel => _weather5daysModel;

  Future<void> fetchWeather(String city) async {
    emit(Loading());
    try {
      _currentWeather = await WeatherApi().fetchWeather(city);
      _weather5daysModel = await WeatherApi().fetchWeatherForecast5DaysByCoordinates(_currentWeather.coord!.lat!, _currentWeather.coord!.lon!);
      emit(LoadedSuccessfully(_currentWeather, _weather5daysModel));
    } catch (error) {
      emit(Error('Error fetching weather data: $error'));
    }
  }

  Future<void> fetchWeatherByLocation() async {
    emit(Loading());
    try {
      Location location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permissions are denied.');
        }
      }

      LocationData locationData = await location.getLocation();

      _currentWeather = await WeatherApi().fetchWeatherByCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );
      _weather5daysModel = await WeatherApi().fetchWeatherForecast5DaysByCoordinates(locationData.latitude!, locationData.longitude!);
      emit(LoadedSuccessfully(_currentWeather, _weather5daysModel));
    } catch (error) {
      emit(Error('Error fetching weather data: $error'));
    }
  }

  String getWeatherAnimation() {
    if (_currentWeather.weather![0].main == 'Clouds') {
      return 'assets/fog.json';
    } else if (_currentWeather.weather![0].main == 'Rain') {
      return 'assets/rain.json';
    } else if (_currentWeather.weather![0].main == 'Thunderstorm') {
      return 'assets/storm.json';
    } else if (_currentWeather.dt! < _currentWeather.sys!.sunset!) {
      return 'assets/sunny.json';
    } else {
      return 'assets/night.json';
    }
  }
}
