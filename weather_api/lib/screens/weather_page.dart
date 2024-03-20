import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherStatePage();
}

class _WeatherStatePage extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('f0eb33dc37cdc394578c0490428b204b');
  Weather? _weather;

  //fetch weather
  _fetchedWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch(e){
      print(e);
    }
  }

  //weather animation
  String getWeatherAnimation(String ?mainCondition){
    if(mainCondition == null) return 'assets/sunny.json';
    switch(mainCondition.toLowerCase()){
      case 'clouds':
        return 'assets/cloudy.json';
      case 'rain':
        return 'assets/rain.json';
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchedWeather();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? 'loading city...'),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Text('${_weather?.temperature.round()}°C'),
            Text(_weather?.mainCondition ?? "")
          ],
        ),
      ),   
    );
  }
}