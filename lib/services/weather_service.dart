import 'package:clima/utilities/networking.dart';
import '../constants/openweathermap_const.dart';
import '../core/request.dart';
import '../core/response.dart';
import '../models/empty_model.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import 'location_service.dart';

WeatherService weatherService = WeatherService();

class WeatherService {
  Future<CResponse<WeatherModel>> getCityWeather(CRequest<String> requestCityName) async {
    NetworkHelper networkHelper = NetworkHelper('$openWeatherMapURL?q=${requestCityName.data}&appid=$apiKey&units=metric');
    CResponse<WeatherModel> weatherResponse = _converToErrorWeatherResponse(requestCityName);

    var weatherData = await networkHelper.getData();

    if (weatherData != null) {
      weatherResponse.isSuccess = true;
      weatherResponse.data = _converToWeatherModel(weatherData);
    }
    return weatherResponse;
  }

  Future<CResponse<WeatherModel>> getLocationWeather(CRequest<EmptyModel> request) async {
    CResponse<LocationModel> cLocationResponse = await locationService.getCurrentLocation(CRequest<EmptyModel>());
    CResponse<WeatherModel> weatherResponse = _converToErrorWeatherResponse(request);

    if (!cLocationResponse.isSuccess) {
      weatherResponse.error = cLocationResponse.error;
      return weatherResponse;
    }

    dynamic weatherData = await _getWeatherData(cLocationResponse);

    if (weatherData != null) {
      weatherResponse.isSuccess = true;
      weatherResponse.data = _converToWeatherModel(weatherData);
    }
    return weatherResponse;
  }

  String _prepareUrl(String latitude, String longitude) {
    return '$openWeatherMapURL?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
  }

  WeatherModel _converToWeatherModel(dynamic weatherData) {
    int condition = weatherData['weather'][0]['id'];
    WeatherModel weatherModel = WeatherModel();
    weatherModel.cityName = weatherData['name'];
    weatherModel.temperature = (weatherData['main']['temp'] as double).toInt();
    weatherModel.weatherIcon = _getWeatherIcon(condition);
    weatherModel.weatherMessage = _getMessage(weatherModel.temperature);

    return weatherModel;
  }

  CResponse<WeatherModel> _converToErrorWeatherResponse(CRequest request) {
    WeatherModel weatherModel = WeatherModel();
    weatherModel.cityName = '';
    weatherModel.temperature = 0;
    weatherModel.weatherIcon = 'Error';
    weatherModel.weatherMessage = 'Unable to get weather data';

    CResponse<WeatherModel> weatherResponse = CResponse<WeatherModel>(
      requestId: request.requestId,
      isSuccess: false,
      data: weatherModel,
    );
    return weatherResponse;
  }

  String _getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String _getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }

  Future<dynamic> _getWeatherData(CResponse<LocationModel> cLocationResponse) async {
    NetworkHelper networkHelper = NetworkHelper(
      _prepareUrl(
        cLocationResponse.data!.latitude.toString(),
        cLocationResponse.data!.longitude.toString(),
      ),
    );

    return await networkHelper.getData();
  }
}
