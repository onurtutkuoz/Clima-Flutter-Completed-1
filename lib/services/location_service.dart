import 'package:geolocator/geolocator.dart';
import '../constants/geo_locator_const.dart';
import '../core/request.dart';
import '../core/response.dart';
import '../models/location_model.dart';

LocationService locationService = LocationService();

class LocationService {
  Future<CResponse<LocationModel>> getCurrentLocation(CRequest request) async {
    CResponse<LocationModel> cResponse = CResponse(requestId: request.requestId, isSuccess: true, data: LocationModel.empty());

    await _determinePosition().catchError((error) {
      cResponse.isSuccess = false;
      cResponse.error!.add(error.toString());
      cResponse.data = LocationModel.empty();
    }).then((Position position) {
      cResponse.data = LocationModel(latitude: position.latitude, longitude: position.longitude);
    });

    return cResponse;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(kLocationServicesDisabledMessage);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(kPermissionDeniedMessage);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(kPermissionDeniedForeverMessage);
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  }
}
