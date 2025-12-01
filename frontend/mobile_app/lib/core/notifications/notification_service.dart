import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:ai_skincare_platform/config/environment.dart';
import 'package:ai_skincare_platform/core/logging/app_logger.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging? _messaging;
  void Function(String? route)? _navigationHandler;

  Future<void> initialize() async {
    await _initLocalNotifications();
    if (!Environment.enablePushNotifications) {
      AppLogger.info(
        'Push notifications disabled for this environment',
        tag: 'Notifications',
      );
      return;
    }
    await _initPushNotifications();
  }

  void setNavigationHandler(void Function(String? route)? handler) {
    _navigationHandler = handler;
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const settings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        _handleNavigationPayload(response.payload);
      },
    );
    tz.initializeTimeZones();
  }

  Future<void> _initPushNotifications() async {
    try {
      await Firebase.initializeApp();
      _messaging = FirebaseMessaging.instance;
      final permission = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (permission.authorizationStatus == AuthorizationStatus.denied) {
        AppLogger.info('Push permission denied');
        return;
      }

      final token = await _messaging!.getToken();
      if (token != null) {
        AppLogger.info('FCM token registered', tag: 'Notifications');
      }

      FirebaseMessaging.onMessage.listen((message) {
        final notification = message.notification;
        if (notification != null) {
          showLocalNotification(
            id: notification.hashCode,
            title: notification.title ?? 'HealZone update',
            body: notification.body ?? '',
            payload: message.data['route'] as String?,
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        _handleNavigationPayload(message.data['route'] as String?);
      });

      final initial = await _messaging!.getInitialMessage();
      if (initial != null) {
        _handleNavigationPayload(initial.data['route'] as String?);
      }
    } catch (error, stackTrace) {
      AppLogger.error('Push notification init failed',
          error: error, stackTrace: stackTrace);
    }
  }

  Future<void> requestLocalPermission() async {
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'healzone_reminders',
      'HealZone Reminders',
      channelDescription: 'Reminders and updates from HealZone',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotificationsPlugin.show(id, title, body, details,
        payload: payload);
  }

  Future<void> scheduleRoutineReminder({
    required TimeOfDay timeOfDay,
    int id = 101,
    String title = 'Nhac nho cham soc da',
    String body = 'Da den gio thuc hien routine hom nay.',
    String? payload,
  }) async {
    final now = DateTime.now();
    final scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    final target = scheduled.isAfter(now)
        ? scheduled
        : scheduled.add(const Duration(days: 1));
    final tzTime = tz.TZDateTime.from(target, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'healzone_reminders',
      'HealZone Reminders',
      channelDescription: 'Routine reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelReminder(int id) {
    return _localNotificationsPlugin.cancel(id);
  }

  void _handleNavigationPayload(String? route) {
    final handler = _navigationHandler;
    if (handler != null && route != null && route.isNotEmpty) {
      handler(route);
    }
  }
}
