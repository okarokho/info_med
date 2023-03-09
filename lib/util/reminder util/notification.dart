import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';

class LocalNotification {
// create notification from now to the last day of notification
  static Future showScheduledNotification(
      {int id = 0,
      String? title,
      String? body,
      required DateTime timeFuture,
      required DateTime timePresent}) async {
    while (timePresent.compareTo(timeFuture) < 0) {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: UniqueKey().hashCode,
              channelKey: 'key1',
              title: title,
              body: body,
              notificationLayout: NotificationLayout.Default),
          schedule: NotificationCalendar.fromDate(date: timePresent));
      timePresent = DateTime(timePresent.year, timePresent.month,
          timePresent.day + 1, timePresent.hour, timePresent.minute);
    }
  }
}
