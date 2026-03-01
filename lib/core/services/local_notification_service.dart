import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:habitly/domain/entities/habit.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void _onBackgroundNotificationResponse(NotificationResponse response) {
  // Can be expanded later for deep linking
}

/// Manages local notifications for habit reminders.
class LocalNotificationService {
  LocalNotificationService({required FlutterLocalNotificationsPlugin plugin})
    : _plugin = plugin;

  final FlutterLocalNotificationsPlugin _plugin;

  // Constants
  static const _channelId = 'habit_reminders';
  static const _channelName = 'Habit Reminders';
  static const _channelDescription = 'Reminder notifications for daily habits';

  // State
  bool _initialized = false;
  AndroidScheduleMode _scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;

  /// Initializes timezone, plugin, notification channel, and permissions.
  Future<void> init() async {
    if (_initialized) return;

    await _configureTimezone();
    await _initPlugin();
    await _createAndroidChannel();
    await _requestPermissions();

    _initialized = true;
  }

  /// Syncs scheduled notifications with the current habit list.
  Future<void> syncHabitReminders(List<Habit> habits) async {
    await init();

    final pendingRequests = await _plugin.pendingNotificationRequests();
    final activeIds = <int>{};

    for (final habit in habits) {
      if (!_shouldSchedule(habit)) continue;

      final scheduleAt = _nextScheduleTime(
        reminderTime: habit.reminderTime!,
        targetDate: habit.targetDate,
      );
      if (scheduleAt == null) continue;

      final id = _habitNotificationId(habit.id);
      activeIds.add(id);
      await _scheduleReminder(id: id, habit: habit, scheduledDate: scheduleAt);
    }

    // Cancel notifications that are no longer active
    for (final request in pendingRequests) {
      if (!activeIds.contains(request.id)) {
        await _plugin.cancel(id: request.id);
      }
    }
  }

  /// Cancels the scheduled notification for a single habit.
  Future<void> cancelHabitReminder(String habitId) async {
    await init();
    await _plugin.cancel(id: _habitNotificationId(habitId));
  }

  /// Cancels all scheduled notifications (e.g. on logout).
  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  // Plugin initialisation
  Future<void> _initPlugin() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse:
          _onBackgroundNotificationResponse,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // TODO: Implement deep link navigation to specific habit
  }

  // Scheduling helpers
  /// Whether a habit qualifies for a scheduled reminder.
  bool _shouldSchedule(Habit habit) {
    if (!habit.hasReminder) return false;
    if (habit.reminderTime == null || habit.reminderTime!.isEmpty) return false;

    // Skip habits whose end date has passed
    if (habit.endDate != null) {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final endDate = DateTime(
        habit.endDate!.year,
        habit.endDate!.month,
        habit.endDate!.day,
      );
      if (endDate.isBefore(todayDate)) return false;
    }

    return true;
  }

  /// Computes the next [tz.TZDateTime] for a reminder in "HH:mm" format.
  /// Returns `null` if the format is invalid.
  tz.TZDateTime? _nextScheduleTime({
    required String reminderTime,
    DateTime? targetDate,
  }) {
    final parts = reminderTime.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    final now = tz.TZDateTime.now(tz.local);
    final baseDate = targetDate ?? now;

    var scheduled = tz.TZDateTime(
      tz.local,
      baseDate.year,
      baseDate.month,
      baseDate.day,
      hour,
      minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  /// Schedules a single reminder notification.
  Future<void> _scheduleReminder({
    required int id,
    required Habit habit,
    required tz.TZDateTime scheduledDate,
  }) => _plugin.zonedSchedule(
    id: id,
    title: 'Habit reminder',
    body: 'Time to do "${habit.name}"',
    scheduledDate: scheduledDate,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    androidScheduleMode: _scheduleMode,
    matchDateTimeComponents: DateTimeComponents.time,
    payload: habit.id,
  );

  /// Deterministic notification ID derived from [habitId].
  int _habitNotificationId(String habitId) {
    var hash = 0;
    for (final unit in habitId.codeUnits) {
      hash = ((hash * 31) + unit) & 0x7fffffff;
    }
    return hash;
  }

  // Platform configuration
  Future<void> _configureTimezone() async {
    tz.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (error) {
      debugPrint('Failed to resolve local timezone: $error');
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> _createAndroidChannel() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );
  }

  Future<void> _requestPermissions() async {
    // Android
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.requestNotificationsPermission();

    final canScheduleExact = await android?.canScheduleExactNotifications();
    if (canScheduleExact == true) {
      _scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
    } else {
      final granted = await android?.requestExactAlarmsPermission();
      if (granted == true) {
        _scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
      }
    }

    // iOS
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }
}
