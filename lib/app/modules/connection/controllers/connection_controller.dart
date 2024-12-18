import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../login/views/login_view.dart';
import '../views/no_connection_view.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      _updateConnectionStatus(connectivityResults.first);
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    // Cek apakah saat ini sedang di halaman login
    bool isLoginPage = Get.currentRoute == '/login';

    if (connectivityResult == ConnectivityResult.none && isLoginPage || Get.currentRoute == '/explore') {
      // Hanya beralih ke halaman no connection jika sedang di halaman login
      Get.offAll(() => const NoConnectionView());
    } else if (connectivityResult != ConnectivityResult.none &&
        Get.currentRoute == '/NoConnectionView') {
      // Kembali ke halaman login jika sudah terhubung kembali
      Get.offAll(() => const LoginView());
    }
  }

  // Metode untuk pengecekan koneksi manual
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
