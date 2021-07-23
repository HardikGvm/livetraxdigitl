import 'package:connectivity/connectivity.dart';

class UserService {
  Future<bool> checkInternetConnectivity() async {
    final Connectivity _connectivity = Connectivity();
    ConnectivityResult result = await _connectivity.checkConnectivity();
    String connection = getConnectionValue(result);
    if (connection == 'None') {
      return false;
    } else {
      return true;
    }
  }

  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }
}
