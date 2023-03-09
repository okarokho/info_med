import 'dart:math';

import 'package:flutter/material.dart';
import 'package:info_med/models/sql/db_reminder.dart';
import 'package:info_med/pages/tracking/widget/month_image.dart';
import 'package:info_med/util/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  late _DataSource events;

  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false).getAllReminders();
    events = _DataSource(_getAppointments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 4),
        // calender view
        child: SfCalendar(
          showDatePickerButton: true,
          // scheduler view
          view: CalendarView.schedule,
          dataSource: events,
          // showing image in month header
          scheduleViewMonthHeaderBuilder: (context, details) =>
              MonthImage(details: details),
          scheduleViewSettings: const ScheduleViewSettings(
            hideEmptyScheduleWeek: true,
            appointmentItemHeight: 50,
            // customizing day header
            dayHeaderSettings: DayHeaderSettings(
              dayFormat: 'EEEE',
              width: 70,
              dayTextStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            // customizing month header
            monthHeaderSettings: MonthHeaderSettings(
              height: 150,
            ),
          ),
        ),
      ),
    );
  }

  List<Appointment> _getAppointments() {
    // random object for colors
    final Random random = Random();
    // list of the appointed drugs
    List<Appointment> appointments = <Appointment>[];
    // list of colors
    List<Color> colorCollection = const <Color>[
      Color(0xFF0F8644),
      Color(0xFF8B1FA9),
      Color(0xFFD20100),
      Color(0xFFFC571D),
      Color(0xFF36B37B),
      Color(0xFF01A1EF),
      Color(0xFF3D4FB5),
      Color(0xFFE47C73),
      Color(0xFF636363),
      Color(0xFF0A8043),
      Color(0xff8F00FF)
    ];

    // list of all reminded drugs in database
    List<DbReminder> listOfAllReminders =
        Provider.of<DataProvider>(context, listen: false).listOfAllReminders;

    // looping though all drugs and adding it as appointed object
    for (final i in listOfAllReminders) {
      final nextDay = DateTime.parse(i.date!);
      final date = DateTime(nextDay.year, nextDay.month, nextDay.day,
          i.timeFuture!.hour, i.timeFuture!.minute, i.timeFuture!.second);
      appointments.add(Appointment(
        subject: i.name.toString(),
        startTime: date,
        endTime: date.add(const Duration(hours: 1)),
        color: colorCollection[random.nextInt(10)],
      ));
    }
    return appointments;
  }
}

// creating an object of type appointment to used in SfCalender
class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
