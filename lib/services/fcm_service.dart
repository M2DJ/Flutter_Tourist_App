import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:my_governate_app/models/notification_model.dart';
import 'package:my_governate_app/providers/notification_provider.dart';

class FCMService {
  // Create an instance of Firebase Messaging
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static NotificationProvider? _notificationProvider;

  static Future<void> initNotifications([NotificationProvider? notificationProvider]) async {
    try {
      if (kIsWeb) {
        print('FCM is not fully supported on web platform');
        return;
      }

      _notificationProvider = notificationProvider;

      await _fcm.requestPermission();

      final fCMToken = await _fcm.getToken();

      print('Token: $fCMToken');

      initPushNotifications();

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        handleMessage(message);
      });
    } catch (e) {
      print('Error initializing FCM: $e');
    }
  }

  static void handleMessage(RemoteMessage? message) {
    // Check if the message is null, do nothing
    if (message == null) return;

    // Create notification model from Firebase message
    final notification = NotificationModel(
      title: message.notification?.title ?? 'إشعار جديد',
      content: message.notification?.body ?? 'لديك إشعار جديد',
      time: 'الآن',
      imagePath: 'assets/images/notifyIcon.png', // Default image
    );

    // Add to notification provider
    _notificationProvider?.addNotification(notification);
    
    print('Received notification: ${notification.title}');
  }

  static Future<void> initPushNotifications() async {
    try {
      if (kIsWeb) return;

      FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    } catch (e) {
      print('Error initializing push notifications: $e');
    }
  }
}
