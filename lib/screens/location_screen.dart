import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../core/request.dart';
import '../core/response.dart';
import '../models/empty_model.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({required this.locationWeather});
  final CResponse<WeatherModel> locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  late int temperature;
  late String weatherIcon;
  late String cityName;
  late String weatherMessage;
  late String backgroundImage;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(CResponse<WeatherModel> weatherData) {
    setState(() {
      temperature = weatherData.data!.temperature;
      weatherIcon = weatherData.data!.weatherIcon;
      weatherMessage = weatherData.data!.weatherMessage;
      cityName = weatherData.data!.cityName;
      backgroundImage = weatherData.data!.backgroundImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            // image: AssetImage('images/location_background.jpg'),
            image: AssetImage('images/$backgroundImage'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () async {
                      var weatherData = await weatherService.getLocationWeather(CRequest<EmptyModel>());
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var weatherData = await weatherService.getCityWeather(CRequest<String>(data: typedName));
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Center(
                //padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 30),
                child: Text(
                  '$weatherMessage in $cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
