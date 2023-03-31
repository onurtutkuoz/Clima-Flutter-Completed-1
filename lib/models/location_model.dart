








class LocationModel {
  LocationModel({
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.empty() {
    return LocationModel(latitude: 0, longitude: 0);
  }

  double latitude = 0;
  double longitude = 0;
}
