
 
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

class LocalNotification{

static Future showScheduledNotification({int id=0,String? title,String? body,required DateTime time}) async {
DateTime timeNow=DateTime.now();
 if(timeNow.day <= time.day && timeNow.month <= time.month && timeNow.year <= time.year && timeNow.hour <= time.hour && timeNow.minute < time.minute){
  
  
  for(int i =timeNow.day;i<=time.day;i++){

     if(i==timeNow.day && timeNow.hour > time.hour || timeNow.minute > time.minute)
      {
        timeNow = DateTime(timeNow.year, timeNow.month, timeNow.day + 1);
      }
      else{
        await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: Random(). nextInt(100000),
          channelKey: 'key1',
          title: title,
          body:body,
          notificationLayout: NotificationLayout.Default),
      schedule: NotificationCalendar.fromDate(date: time));
      timeNow = DateTime(timeNow.year, timeNow.month, timeNow.day + 1,timeNow.hour,timeNow.minute);

      }

      
 }
 }
}
}