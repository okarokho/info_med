
 

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';

class LocalNotification{

static Future showScheduledNotification({int id=0,String? title,String? body,required DateTime timeFuture,required DateTime timePresent}) async {
 
 if(timePresent.day <= timeFuture.day && timePresent.month <= timeFuture.month && timePresent.year <= timeFuture.year && timePresent.hour <= timeFuture.hour && timePresent.minute <= timeFuture.minute){
  
  while(timePresent.compareTo(timeFuture) < 1) {

    if(timePresent.compareTo(timeFuture) == 0 ) {
      timePresent = DateTime(timePresent.year,timePresent.month,timePresent.day+1,timePresent.hour,timePresent.minute);
    } else { 
      await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: UniqueKey().hashCode,
          channelKey: 'key1',
          title: title,
          body:body,
          notificationLayout: NotificationLayout.Default),
      schedule: NotificationCalendar.fromDate(date: timePresent));
      timePresent = DateTime(timePresent.year,timePresent.month,timePresent.day+1,timePresent.hour,timePresent.minute);
      }
    }
   }
  }
}