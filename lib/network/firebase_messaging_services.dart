import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _onBackgroundMessageHandler(RemoteMessage message) async {
  log('on background message handler ${message.data}');
}

class FirebaseMessagingService {
  factory FirebaseMessagingService() {
    return _singleton;
  }

  FirebaseMessagingService._internal();

  static final FirebaseMessagingService _singleton = FirebaseMessagingService._internal();

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static String? token;

  AndroidNotificationChannel? channel;

  StreamSubscription<RemoteMessage>? onFrontEndStream;
  late StreamSubscription<RemoteMessage> onOpenAppStream;
  late StreamSubscription<String> tokenStream;

  static Future<void> initializeMain() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessageHandler);
  }

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    await _onOpenedAppFromTerminateMessage();

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.high,
        playSound: true,
      );

      const initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_notification');

      final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (_, __, ___, ____) async {},
      );

      final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: _onOpenedLocalNotification,
      );

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the AndroidManifest.xml file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel!);

      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      _onFrontEndMessage(flutterLocalNotificationsPlugin);
    }

    await _setToken();

    _onOpenedAppMessage();
  }

  Future<void> _onOpenedAppFromTerminateMessage() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      log('on teminated opended App message $initialMessage');
    }
  }

  Future<void> _onOpenedLocalNotification(String? payload) async {
    if (payload != null) {
      log(payload.toString());
      log(jsonDecode(payload)['data']);
      log(jsonDecode(payload)['data']);
    }

    log('on local notification opended App message $payload');
  }

  void _onOpenedAppMessage() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        log('on frontend opended App message $message');
      },
    );
  }

  void _onFrontEndMessage(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    onFrontEndStream = FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb && channel != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel!.name,
              channelDescription: channel!.description,
              icon: "@drawable/ic_notification",
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });
  }

  Future _setToken() async {
    token = await _firebaseMessaging.getToken();

    tokenStream = _firebaseMessaging.onTokenRefresh.listen((newToken) {
      token = newToken;
    });
  }

  void dispose() {
    onFrontEndStream?.cancel();
    onOpenAppStream.cancel();
    tokenStream.cancel();
  }
}
