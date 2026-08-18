import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();

  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> showApproachingNotification() async {
    // Debug log to confirm notification calls during development
    // (Remove or guard this in production)
    // ignore: avoid_print
    print('NotificationService: showApproachingNotification called');
    const androidDetails = AndroidNotificationDetails(
      'waitless_channel',
      'Queue Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      0,
      'Your turn is approaching!!',
      'Move to the allotted room ASAP',
      details,
    );
  }
}