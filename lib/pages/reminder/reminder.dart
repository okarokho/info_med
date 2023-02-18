import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:info_med/constants/colors.dart';
import 'package:info_med/util/database.dart';
import 'package:info_med/util/provider.dart';
import 'package:info_med/widgets/title_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'widget/create_reminder.dart';

// ignore: must_be_immutable
class Reminder extends StatefulWidget {
   const Reminder({super.key});


static DateTime date = DateTime.now();
  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {

  

  @override
  void initState() {
    context.read<DataProvider>().getDataReminder(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
            // celendar days list
            Container(
            width: 345,
            margin: const EdgeInsets.symmetric( horizontal: 23,vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10)
            ),
            child: DatePicker(
                    DateTime.now(),
                    height: 90,
                    width: 80,
                    locale: AppLocalizations.of(context)!.local,
                    onDateChange: (selectedDate) => setState(() {
                      Reminder.date=selectedDate;
                      context.read<DataProvider>().getDataReminder(selectedDate);
                    }),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: purple,
                    selectedTextColor: Colors.white,
                    dateTextStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey
                    ),
                  ),
                ),
            // list of remiders from database
            Expanded(
              child: Consumer<DataProvider>(
                builder: (context,data,child) =>data.listReminder.isNotEmpty
                ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.listReminder.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.grey[200],
                        child: GestureDetector(
                          onDoubleTap: () {
                            databaseHelper.instance.deleteR(data.listReminder[index].name.toString(),data.listReminder[index].date.toString());
                           context.read<DataProvider>().getDataReminder(Reminder.date);
                          }, 
                          child: ListTile(
                            leading: Image.asset(data.listReminder[index].image.toString()),
                            title: Text(data.listReminder[index].name.toString()),
                            subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [Text(data.listReminder[index].dose.toString()),
                                const SizedBox(width: 5,),
                                Text(data.listReminder[index].type.toString()),
                                ],),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(Icons.timer,color: purple,),
                                Text(DateFormat('h:mm a').format(data.listReminder[index].timeFuture!))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },)
                : Center(child: TitleText(txt: AppLocalizations.of(context)!.noDrug,size: 20))
                ),
              )
            ],
          )
        ),
        // floating action button to add reminder
        SafeArea(
          child: Align(
            alignment: AppLocalizations.of(context)!.language != 'English' ? Alignment.bottomLeft:Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                elevation: 10,
                child: const Icon(Icons.add_alert_rounded,color:purple,size: 33,), 
                onPressed: () => showModalBottomSheet(
                isDismissible: false,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              context: context, 
              builder: (context) {
                 return const AddMedicine();
               },
              ),
             ),
            )
          ),
        )
      ],
    );
  }
}
