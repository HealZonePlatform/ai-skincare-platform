/// Placeholder notification service to be wired when push/local notification
/// infrastructure is available. Keeps API surface ready without adding deps now.
class LocalNotificationService {
  Future<void> scheduleRoutineReminder({
    required String id,
    required DateTime time,
    required String title,
    required String body,
  }) async {
    // TODO: integrate flutter_local_notifications and hook routine reminders.
  }

  Future<void> cancel(String id) async {
    // TODO: cancel scheduled notification.
  }
}
