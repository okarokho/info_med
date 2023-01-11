
 

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';

class LocalNotification{

static Future showScheduledNotification({int id=0,String? title,String? body,required DateTime timeFuture}) async {
 
DateTime timeNow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day ,timeFuture.hour,timeFuture.minute);

 if(timeNow.day <= timeFuture.day && timeNow.month <= timeFuture.month && timeNow.year <= timeFuture.year && timeNow.hour <= timeFuture.hour && timeNow.minute <= timeFuture.minute){
  
  for(int i =timeNow.day;i<=timeFuture.day;i++){

     if(i==timeNow.day && timeNow.hour > timeFuture.hour || timeNow.minute > timeFuture.minute)
      {
      timeNow = DateTime(timeNow.year, timeNow.month, timeNow.day + 1,timeNow.hour,timeNow.minute);
      }
      else{
        await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: UniqueKey().hashCode,
          channelKey: 'key1',
          title: title,
          body:body,
          notificationLayout: NotificationLayout.Default),
      schedule: NotificationCalendar.fromDate(date: timeNow));
      timeNow = DateTime(timeNow.year, timeNow.month, timeNow.day + 1,timeNow.hour,timeNow.minute);
      

      }
 }
 }
}
}