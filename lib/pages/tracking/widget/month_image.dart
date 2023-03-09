import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonthImage extends StatelessWidget {
  const MonthImage({super.key, required this.details});
  final ScheduleViewMonthHeaderDetails details;

  // name of all month in different langueges
  final List<String> _arabicMonth = const [
    "يناير",
    "فبراير",
    "مارس",
    "أبريل",
    "مايو",
    "يونيو",
    "يوليو",
    "أغسطس",
    "سبتمبر",
    "أكتوبر",
    "نوفمبر",
    "ديسمبر"
  ];
  final List<String> _kurdishMonth = const [
    "کانوونی دووەم",
    "شوبات",
    "ئادار",
    "نیسان",
    "مایس",
    "حوزەیران",
    "تەموز",
    "ئاب",
    "ئەیلوول",
    "تشرینی یەکەم",
    "تشرینی دووەم",
    "کانوونی یەکەم"
  ];
  final List<String> _englishMonth = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  Widget build(BuildContext context) {
    final String monthName = AppLocalizations.of(context)!.local == 'en'
        ? _englishMonth[details.date.month - 1]
        : AppLocalizations.of(context)!.local == 'ar'
            ? _arabicMonth[details.date.month - 1]
            : AppLocalizations.of(context)!.local == 'ku'
                ? _kurdishMonth[details.date.month - 1]
                : '';
    return Stack(
      children: [
        // month image
        Image(
            image: ExactAssetImage(
                'assets/images/months/${_englishMonth[details.date.month - 1]}.png'),
            fit: BoxFit.cover,
            width: details.bounds.width,
            height: details.bounds.height),
        // month name
        AppLocalizations.of(context)!.local != 'en'
            ? Positioned(
                left: 0,
                right: 8,
                top: 15,
                bottom: 0,
                child: Text(
                  '$monthName ${details.date.year}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
            : Positioned(
                left: 8,
                right: 0,
                top: 15,
                bottom: 0,
                child: Text(
                  '$monthName ${details.date.year}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
      ],
    );
  }
}
