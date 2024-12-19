import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../views/no_connection_view.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;
  String? _lastRoute;
  Map<String, dynamic>? _lastArguments;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _setupConnectivityStream();
  }

  Future<void> _initConnectivity() async {
    var result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result.first);
  }

  void _setupConnectivityStream() {
    _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results.first);
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    isConnected.value = connectivityResult != ConnectivityResult.none;

    if (!isConnected.value) {
      if (Get.currentRoute != '/NoConnectionView' &&
          !(Get.currentRoute == '/home' ||
              Get.currentRoute == '/service-booking')) {
        _lastRoute = Get.currentRoute;
        _lastArguments = Get.arguments;
        Get.offAll(() => const NoConnectionView());
      }
    } else if (Get.currentRoute == '/NoConnectionView' && _lastRoute != null) {
      Get.offAllNamed(_lastRoute!, arguments: _lastArguments);
      _lastRoute = null;
      _lastArguments = null;
    }
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
