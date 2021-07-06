import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

//
// v2.0 - 29/09/2020
//

class MyLocation {
  Geolocator _geolocator = Geolocator();
  Position _currentPosition;

  Future<Position> getCurrent() async {
    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .timeout(Duration(seconds: 10), onTimeout: () async {
      return await Geolocator.getLastKnownPosition().timeout(Duration(seconds: 10));
    });
    return _currentPosition;
  }

  distance(double lat, double lng) async {
    var _distanceInMeters = -1.0;

    if (Permission.location.isGranted != null) {
      if (_currentPosition == null)
        await getCurrent();

      if (_currentPosition != null) {
        _distanceInMeters = await Geolocator.distanceBetween(
            _currentPosition.latitude, _currentPosition.longitude,
            lat, lng);
      }
    }
    return _distanceInMeters;
  }

  distanceBetween(double lat, double lng, double lat2, double lng2) async {
    var _distanceInMeters = -1.0;
    _distanceInMeters = await Geolocator.distanceBetween(
        lat2, lng2,
        lat, lng);
    return _distanceInMeters;
  }
}