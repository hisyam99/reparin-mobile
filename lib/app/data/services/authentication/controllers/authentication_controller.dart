import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/profile_model.dart';

class AuthenticationController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  final obscurePassword = true.obs;
  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoggedIn = false.obs;
  final RxString userRole = 'user'.obs; // Menambahkan RxString untuk role

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    user.bindStream(_auth.authStateChanges());
    ever(user, _initialScreen);
    checkLoginStatus(); // Periksa status login saat controller diinisialisasi
    // Cek token tersimpan saat inisialisasi
    final savedToken = _prefs.getString('user_token');
    if (savedToken != null) {
      isLoggedIn.value = true;
    }
  }

  // Periksa status login menggunakan Shared Preferences dan Firebase Auth
  Future<void> checkLoginStatus() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      isLoggedIn.value = true;
      await fetchUserRole(currentUser.uid);
    } else {
      isLoggedIn.value = false;
    }
  }

  // Fetch user role from Firestore
  Future<void> fetchUserRole(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      final profile = Profile.fromFirestore(doc);
      userRole.value = profile.role.value;
    } else {
      userRole.value = 'user'; // Default role jika tidak ditemukan di Firestore
    }
  }

  // Handle initial screen routing based on auth state
  _initialScreen(User? user) {
    if (user != null) {
      // User is logged in, navigate to home
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Metode login baru
  Future<void> login() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      // Validasi input sebelum login
      if (!_validateLoginInputs()) {
        Get.back();
        Get.snackbar(
          'Error',
          'Email dan password harus diisi dengan benar',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      // Simpan token dengan informasi lebih lengkap
      String? token = await userCredential.user!.getIdToken();
      await _prefs.setString('user_token', token ?? '');
      await _prefs.setString('user_email', userCredential.user!.email ?? '');
      isLoggedIn.value = true;
      await fetchUserRole(userCredential.user!.uid); // Fetch role setelah login
      Get.back(); // Tutup dialog loading
      _clearControllers();
      Get.snackbar(
        'Success',
        'Login berhasil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.back();
      String errorMessage = 'Login gagal';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Pengguna tidak ditemukan';
          break;
        case 'wrong-password':
          errorMessage = 'Password salah';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid';
          break;
      }
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Login gagal: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> signUp() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      if (!_validateInputs()) {
        Get.back();
        Get.snackbar(
          'Error',
          'Harap isi semua field dengan benar',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }
      // Create user in Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      // Create user profile in Firestore with role 'user'
      await createUserProfile(userCredential.user!, 'user');
      // Simpan token pengguna di Shared Preferences
      String? token = await userCredential.user!.getIdToken();
      await _prefs.setString('user_token', token ?? '');
      await _prefs.setString('user_email', userCredential.user!.email ?? '');
      isLoggedIn.value = true;
      await fetchUserRole(
          userCredential.user!.uid); // Fetch role setelah sign up
      Get.back(); // Close loading dialog
      _clearControllers();
      Get.snackbar(
        'Success',
        'Akun berhasil dibuat',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Gagal membuat akun: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  void _clearControllers() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
  }

  bool _validateLoginInputs() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        GetUtils.isEmail(emailController.text.trim());
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return false;
    }
    // Basic email validation
    if (!GetUtils.isEmail(emailController.text.trim())) {
      return false;
    }
    // Basic phone number validation
    if (!GetUtils.isPhoneNumber(phoneController.text.trim())) {
      return false;
    }
    // Basic password strength validation
    if (passwordController.text.length < 6) {
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      // Hapus token dari Shared Preferences
      await _prefs.remove('user_token');
      await _prefs.remove('user_email');
      isLoggedIn.value = false;
      userRole.value = 'user'; // Reset role to 'user' on logout
      // Sign out from Firebase
      await _auth.signOut();
      // Close loading dialog
      Get.back();
      // Show success message
      Get.snackbar(
        'Success',
        'Logout berhasil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      // Navigate to sign in view
      Get.offAllNamed('/login');
    } catch (e) {
      // Close loading dialog
      Get.back();
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat logout',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> createUserProfile(User user, String role) async {
    try {
      final profile = Profile(
        id: user.uid,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        role: role, // Set role to 'user' during registration
      );
      await _firestore.collection('users').doc(user.uid).set(profile.toJson());
    } catch (e) {
      throw 'Gagal membuat profil pengguna: $e';
    }
  }
}
