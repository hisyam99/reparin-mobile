import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Inisialisasi kanal notifikasi untuk Android
  final _androidChannel = const AndroidNotificationChannel(
    'channel_notification',
    'High Importance Notification',
    description: 'Used For Notification',
    importance: Importance.defaultImportance,
  );

  // Inisialisasi plugin notifikasi lokal
  final _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> initPushNotification() async {
    // Meminta izin notifikasi dari pengguna
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('Izin yang diberikan pengguna: ${settings.authorizationStatus}');

    // Mendapatkan token FCM
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });

    // Handler untuk notifikasi ketika aplikasi di foreground
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      // Tampilkan notifikasi lokal
      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
      print(
          'Pesan diterima saat aplikasi di foreground: ${message.notification?.title}');
    });

    // Handler ketika pesan dibuka dari notifikasi
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Pesan dibuka dari notifikasi: ${message.notification?.title}');
    });
  }

  Future<void> initLocalNotification() async {
    const ios = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotification.initialize(settings);
  }

  static const String _channelId = "your_channel_id";
  static const String _channelName = "your_channel_name";
  static const String _channelDesc = "your_channel_description";

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    // Pengaturan notifikasi untuk Android
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    // Pengaturan notifikasi untuk iOS
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    // Detail pengaturan notifikasi untuk platform Android dan iOS
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Menampilkan notifikasi
    await flutterLocalNotificationsPlugin.show(
      0, // ID unik untuk notifikasi
      'plain title', // Judul notifikasi
      'plain body', // Isi notifikasi
      platformChannelSpecifics, // Detail pengaturan notifikasi
      payload: 'plain notification', // Data payload untuk notifikasi
    );
  }
}
