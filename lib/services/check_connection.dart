import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';

Future<bool> checkInternetConnection(
    FlutterNetworkConnectivity flutterNetworkConnectivity) async {
  try {
    return true;
  } catch (e) {
    return false;
  }
}
