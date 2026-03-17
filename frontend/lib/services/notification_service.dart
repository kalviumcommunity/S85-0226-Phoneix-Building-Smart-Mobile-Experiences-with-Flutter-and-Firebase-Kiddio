import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Top-level function required by FCM for handling background messages.
/// Must be a top-level function (not a class method).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background message received: ${message.messageId}');
  debugPrint('   Title : ${message.notification?.title}');
  debugPrint('   Body  : ${message.notification?.body}');
}

/// Singleton service that initialises Firebase Cloud Messaging,
/// requests permissions, retrieves the device token, and sets up
/// foreground / background / terminated-state message listeners.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Most recent FCM device token (null until [initialize] completes).
  String? deviceToken;

  /// Callbacks that screens can register to react to incoming messages.
  final List<void Function(RemoteMessage)> _foregroundListeners = [];

  /// Call once from main() after Firebase.initializeApp().
  Future<void> initialize() async {
    // 1. Register the background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 2. Request notification permissions (iOS + Android 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');

    // 3. Get the device token
    deviceToken = await _messaging.getToken();
    debugPrint('🔔 FCM Token: $deviceToken');

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      deviceToken = newToken;
      debugPrint('🔔 FCM Token refreshed: $newToken');
    });

    // 4. Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🔔 Foreground message: ${message.notification?.title}');
      for (final cb in _foregroundListeners) {
        cb(message);
      }
    });

    // 5. Handle notification taps when app was in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🔔 Opened app from background notification: '
          '${message.notification?.title}');
    });

    // 6. Handle notification that launched the app from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('🔔 App opened from terminated state via notification: '
          '${initialMessage.notification?.title}');
    }
  }

  /// Register a callback that fires for every foreground message.
  void addForegroundListener(void Function(RemoteMessage) callback) {
    _foregroundListeners.add(callback);
  }

  /// Remove a previously registered foreground callback.
  void removeForegroundListener(void Function(RemoteMessage) callback) {
    _foregroundListeners.remove(callback);
  }
}
