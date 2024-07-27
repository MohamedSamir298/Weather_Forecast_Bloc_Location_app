import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc_5days_location_app/cubit/cubit.dart';
import 'package:weather_bloc_5days_location_app/utils/http_override_request.dart';
import 'package:weather_bloc_5days_location_app/views/weather_screen.dart';
import 'cubit/bloc_observer.dart';
import 'data/services/weather_api.dart';

void main() {
  if(kDebugMode){
    Bloc.observer = MyBLocObserver();
  }
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit(WeatherApi()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          // useMaterial3: false,
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
