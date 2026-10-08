import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you need Firebase services here, make sure Firebase.initializeApp()
  // has already run (it's usually safe since the main isolate already did it).
  debugPrint('Handling a background message: ${message.messageId}');
}


class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  /// Android notification channel used for local notification display.
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  /// Called when a user taps a notification (foreground local notification
  /// or one that opened the app from background/terminated state).
  /// Set this from your app to handle navigation.
  void Function(RemoteMessage message)? onNotificationTap;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Call this once, early in main(), after Firebase.initializeApp().
  Future<void> initialize() async {
    // Register the background handler (must be done before runApp or
    // at least before any background messages can arrive).
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _initLocalNotifications();
    await _createAndroidChannel();
    await _setupToken();
    _registerMessageHandlers();
  }

  /// Requests notification permission. Required on iOS and Android 13+.
  Future<NotificationSettings> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('Notification permission status: ${settings.authorizationStatus}');
    return settings;
  }

  /// Sets up local notifications so foreground FCM messages can be
  /// displayed as a system notification (FCM does not do this for you
  /// on Android when the app is in the foreground).
  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/noti_icon');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle tap on a local notification while app is running.
        debugPrint('Local notification tapped: ${response.payload}');
      },
    );
  }

  Future<void> _createAndroidChannel() async {
    if (!kIsWeb && Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }
  }

  /// Fetches the current FCM token and listens for refreshes.
  /// Send this token to your backend so it can target this device.
  Future<void> _setupToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      debugPrint('FCM Token: $_fcmToken');

    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
    }

    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      debugPrint('FCM Token refreshed: $newToken');
  
    });
  }

  void _registerMessageHandlers() {
    // 1. App is in the FOREGROUND when a message arrives.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.messageId}');
      _showLocalNotification(message);
    });

    // 2. App was in the BACKGROUND (not terminated) and user tapped
    //    the notification to open/resume the app.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification caused app to open from background');
      onNotificationTap?.call(message);
    });

    // 3. App was TERMINATED and was opened via a notification tap.
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App opened from terminated state via notification');
        onNotificationTap?.call(message);
      }
    });
  }

  /// Displays a system notification for a foreground FCM message.
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: android?.smallIcon ?? '@mipmap/noti_icon',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  /// Subscribe this device to a topic (e.g. 'news', 'promo').
  Future<void> subscribeToTopic(String topic) => _messaging.subscribeToTopic(topic);

  /// Unsubscribe this device from a topic.
  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);
}