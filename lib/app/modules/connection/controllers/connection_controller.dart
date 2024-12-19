import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../views/no_connection_view.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  // Store the last route before losing connection
  String? _lastRoute;
  Map<String, dynamic>? _lastArguments;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results.first);
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      // Store current route and arguments before navigating to no connection view
      if (Get.currentRoute != '/NoConnectionView') {
        _lastRoute = Get.currentRoute;
        _lastArguments = Get.arguments;
        Get.offAll(() => const NoConnectionView());
      }
    } else if (connectivityResult != ConnectivityResult.none &&
        Get.currentRoute == '/NoConnectionView') {
      // Return to the last route if it exists, otherwise go to home
      if (_lastRoute != null) {
        Get.offAllNamed(_lastRoute!, arguments: _lastArguments);
        // Clear stored route after navigation
        _lastRoute = null;
        _lastArguments = null;
      }
    }
  }

  // Method for manual connection check
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Method to get the last route before connection loss
  String? getLastRoute() => _lastRoute;
}