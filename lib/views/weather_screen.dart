import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../constants/strings.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  bool isSearchOpen = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<WeatherCubit>(context).fetchWeatherByLocation();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = WeatherCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              isSearchOpen = !isSearchOpen;
            });
          },
        ),
        title:isSearchOpen?TextField(
          controller: _cityController,
          decoration: InputDecoration(
            labelText: 'Enter city',
            suffixIcon: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.saved_search_outlined,),
              onPressed: () {
                if (_cityController.text.isNotEmpty) {
                  cubit.fetchWeather(_cityController.text);
                }
              },
            ),
          ),
        ):const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              cubit.fetchWeatherByLocation();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            const SizedBox(height: 10),
            Center(
              child: BlocConsumer<WeatherCubit, WeatherStates>(
                listener: (context, state) {
                  if (state is LoadedSuccessfully) {
                    setState(() {
                      _cityController.text = "";
                      isSearchOpen = false;
                    });

                  }
                },
                builder: (context, state) {
                  if (state is Loading) {
                    return const CircularProgressIndicator();
                  } else if (state is Error) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        //city name
                        // lottie
                        // temp
                        // list of 5 days weather
                        const Icon(Icons.location_pin),
                        Text(
                          cubit.currentWeather.name ?? "",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        //const SizedBox(height: 10),
                        Lottie.asset(
                          cubit.getWeatherAnimation(),
                          width: 200,
                          height: 200,
                        ),
                        //const SizedBox(height: 10),
                        Text(
                          '${cubit.currentWeather.main!.temp!.ceil()} °C',
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          cubit.currentWeather.weather![0].description ?? "",
                          style: const TextStyle(fontSize: 12),
                        ),
                        // const SizedBox(height: 20),
                        Text(
                          'Humidity: ${cubit.currentWeather.main!.humidity}%',
                          style: const TextStyle(fontSize: 10),
                        ),
                        Text(
                          'Wind Speed: ${cubit.currentWeather.wind!.speed} m/s',
                          style: const TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 170,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.separated(itemBuilder: dayWeatherItemBuilder, separatorBuilder: separatorBuilder, itemCount: cubit.weather5daysModel.list!.length,scrollDirection: Axis.horizontal,shrinkWrap: true,)
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget separatorBuilder(BuildContext context, int index, ) {
  return const SizedBox(width: 10,);
}
Widget dayWeatherItemBuilder(BuildContext context, int index) {
  final cubit = WeatherCubit.get(context);
  return Column(
    children: [
      Text(cubit.weather5daysModel.list?[index].dtTxt?.split(" ")[0] ?? "",style: const TextStyle(fontSize: 10),),
      Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.grey)),
        child: Column(
          children: [
            //time
            // temp
            //icon
            //humidity

            Text(cubit.weather5daysModel.list?[index].dtTxt?.split(" ")[1] ?? ""),
            Text("${cubit.weather5daysModel.list?[index].main?.temp?.ceil()} °C"),
            SizedBox(height:80,child: Image.network("$weatherIconUrl${cubit.weather5daysModel.list?[index].weather?[0].icon}@2x.png")),
            Text('Humidity: ${cubit.weather5daysModel.list?[index].main?.humidity}%',)
          ],
        ),
      ),
    ],
  );
}
