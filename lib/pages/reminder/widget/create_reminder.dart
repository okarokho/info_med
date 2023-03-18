import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:info_med/constants/drugs.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/sql/db_reminder.dart';
import '../../../util/database/database.dart';
import '../../../util/reminder util/notification.dart';
import '../../../util/provider/provider.dart';
import '../reminder.dart';
import 'textfield.dart';

// ignore: must_be_immutable
class AddMedicine extends StatefulWidget {
  const AddMedicine({
    Key? key,
  }) : super(key: key);

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final List<String> _images = [
    'assets/images/list/capsule.png',
    'assets/images/list/pills.png',
    'assets/images/list/syringe.png',
    'assets/images/list/syrup.png',
  ];

  String? type;
  String? time;

  final List<String> _listOfMeasurementEnglish = [
    'Tabs',
    'Capsule',
    'mg',
    '(cc / ml)'
  ];
  final List<String> _listOfMeasurementArabic = [
    'تاب',
    'کبسولة',
    'ملغ',
    '(ملل/ سي سي)'
  ];
  final List<String> _listOfMeasurementKurdish = [
    'تاب',
    'کەپسول',
    'ملگ',
    '(ملل/ سی سی)'
  ];

  final List<String> _listOfTypeEnglish = [
    'Capsule',
    'Pills',
    'Syringe',
    'Syrup'
  ];
  final List<String> _listOfTypeArabic = ['کبسولة', 'حبة', 'محقنة', 'شراب'];
  final List<String> _listOfTypeKurdish = ['کەپسول', 'حەب', 'سرنج', 'شروب'];

  final List<String> _listOfTimeEnglish = [
    'After meal',
    'With meal',
    'Before meal'
  ];
  final List<String> _listOfTimeArabic = [
    'بعد الوجبات',
    'مع الوجبات',
    'قبل الوجبات'
  ];
  final List<String> _listOfTimeKurdish = ['دوای نان', 'لەگەڵ نان', 'پێش نان'];

  late List<String> _listOfMeasurementTemp;
  late List<String> _listOfTypeTemp;
  late List<String> _listOfTimeTemp;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _dose = TextEditingController();
  int _isSelected = 0;
  List<DateTime?>? _pickedDate;
  TimeOfDay? _pickedTime;
  bool _dateFlage = false;
  bool _timeFlage = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _name.dispose();
    _dose.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listOfMeasurementTemp = AppLocalizations.of(context)!.local == 'en'
        ? _listOfMeasurementEnglish
        : AppLocalizations.of(context)!.local == 'ar'
            ? _listOfMeasurementArabic
            : _listOfMeasurementKurdish;
    _listOfTimeTemp = AppLocalizations.of(context)!.local == 'en'
        ? _listOfTimeEnglish
        : AppLocalizations.of(context)!.local == 'ar'
            ? _listOfTimeArabic
            : _listOfTimeKurdish;
    _listOfTypeTemp = AppLocalizations.of(context)!.local == 'en'
        ? _listOfTypeEnglish
        : AppLocalizations.of(context)!.local == 'ar'
            ? _listOfTypeArabic
            : _listOfTypeKurdish;

    return DraggableScrollableSheet(
      initialChildSize: 0.765,
      minChildSize: 0.3,
      maxChildSize: 0.765,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Container(
          color: Colors.white,
          child: Form(
            key: formKey,
            child: ListView(
              controller: scrollController,
              children: [
                // displaying images
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 30),
                  child: SizedBox(
                    height: 115,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _images.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => setState(() => _isSelected = index),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Container(
                              color: _isSelected == index
                                  ? Colors.grey[300]
                                  : Colors.white,
                              height: 80.0,
                              width: 79.0,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    index == 3
                                        ? Image.asset(
                                            _images[index],
                                            height: 73.9,
                                            width: 60,
                                          )
                                        : Image.asset(
                                            _images[index],
                                          ),
                                    Baseline(
                                      baseline: 15,
                                      baselineType: TextBaseline.alphabetic,
                                      child: Text(_listOfTypeTemp[index]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // name field
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35, top: 10),
                  child: SizedBox(
                    height: 80,
                    child: ReminderTextField(
                        controller: _name,
                        label: AppLocalizations.of(context)!.drugName,
                        errorMessage: AppLocalizations.of(context)!.nameError,
                        keyboardType: TextInputType.name),
                  ),
                ),
                // drug dose & type
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // dose
                      SizedBox(
                        height: 80,
                        width: 137,
                        child: ReminderTextField(
                            controller: _dose,
                            label: AppLocalizations.of(context)!.dose,
                            errorMessage:
                                AppLocalizations.of(context)!.doseNumber,
                            keyboardType: TextInputType.number),
                      ),
                      // type
                      SizedBox(
                          height: 80,
                          width: 150,
                          child: DropdownButtonFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              labelText: AppLocalizations.of(context)!.type,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            value: type,
                            borderRadius: BorderRadius.circular(12),
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                type = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                type = value;
                              });
                            },
                            validator: (String? value) {
                              if (value != null) {
                                if (value.isEmpty) {
                                } else {
                                  return null;
                                }
                              } else {
                                return AppLocalizations.of(context)!.drugType;
                              }
                              return null;
                            },
                            items: _listOfMeasurementTemp.map((String val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                ),
                              );
                            }).toList(),
                          )),
                    ],
                  ),
                ),
                // when to take meal
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35, top: 10),
                  child: SizedBox(
                      height: 80,
                      child: DropdownButtonFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8),
                          labelText: AppLocalizations.of(context)!.whenToTake,
                          prefixIcon: const Icon(Icons.dinner_dining_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: time,
                        borderRadius: BorderRadius.circular(12),
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            time = value;
                          });
                        },
                        onSaved: (value) {
                          setState(() {
                            time = value;
                          });
                        },
                        validator: (String? value) {
                          if (value != null) {
                            if (value.isEmpty) {
                            } else {
                              return null;
                            }
                          } else {
                            return AppLocalizations.of(context)!.drugTime;
                          }
                          return null;
                        },
                        items: _listOfTimeTemp.map((String val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Text(
                              val,
                            ),
                          );
                        }).toList(),
                      )),
                ),
                // select time & date
                Padding(
                  padding: _timeFlage == true &&
                          AppLocalizations.of(context)!.local == 'ku'
                      ? const EdgeInsets.only(top: 8.0, left: 14, right: 14)
                      : const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // time
                      InkWell(
                        onTap: () async {
                          final test = await showTimePicker(
                              context: context,
                              errorInvalidText:
                                  AppLocalizations.of(context)!.invalidTime,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.dialOnly);
                          setState(() {
                            if (test != null) _timeFlage = true;
                            _pickedTime = test;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: _timeFlage == true &&
                                  AppLocalizations.of(context)!.local == 'ku'
                              ? 170
                              : 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[300],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                _timeFlage == true
                                    ? TimeOfDay(
                                            hour: _pickedTime!.hour,
                                            minute: _pickedTime!.minute)
                                        .format(context)
                                    : AppLocalizations.of(context)!.empty,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.access_time_rounded,
                                size: 30,
                                color: Colors.grey[800],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // date
                      InkWell(
                        onTap: () async {
                          final test = await showCalendarDatePicker2Dialog(
                            context: context,
                            config: CalendarDatePicker2WithActionButtonsConfig(
                              calendarType: CalendarDatePicker2Type.range,
                              firstDayOfWeek:
                                  AppLocalizations.of(context)!.local == 'en'
                                      ? 1
                                      : 6,
                              weekdayLabels:
                                  AppLocalizations.of(context)!.local == 'ku'
                                      ? weekdays
                                      : null,
                            ),
                            dialogSize: const Size(300, 425),
                            initialValue: [DateTime.now()],
                            borderRadius: BorderRadius.circular(15),
                          );
                          setState(() {
                            if (test != null) {
                              if (test.length == 2) {
                                _dateFlage = true;
                                _pickedDate = test;
                              }
                            }
                          });
                        },
                        child: Container(
                          height: 50,
                          width: _timeFlage == true &&
                                  AppLocalizations.of(context)!.local == 'ku'
                              ? 100
                              : 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[300],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                _dateFlage == true
                                    ? DateFormat("dd.MM", 'ku')
                                        .format(_pickedDate![1]!)
                                    : AppLocalizations.of(context)!.empty,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.event,
                                size: 30,
                                color: Colors.grey[800],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // save button
                Consumer<DatabaseHelper>(
                  builder: (context, value, child) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(400, 40)),
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final temp = DateTime(
                              _pickedDate![0]!.year,
                              _pickedDate![0]!.month,
                              _pickedDate![0]!.day,
                              _pickedTime!.hour,
                              _pickedTime!.minute);
                          final temp2 = DateTime(
                              _pickedDate![1]!.year,
                              _pickedDate![1]!.month,
                              _pickedDate![1]!.day,
                              _pickedTime!.hour,
                              _pickedTime!.minute);
                          var test = DbReminder(
                              name: _name.text.trim(),
                              date: DateFormat('yyyy-MM-dd', 'ku')
                                  .format(_pickedDate![1]!),
                              timeFuture: temp2,
                              timePresent: temp,
                              dose: int.parse(_dose.text),
                              when: time,
                              image: _images[_isSelected],
                              type: type);

                          value.insertReminder(test.tojson(), temp2, temp);
                          context
                              .read<DataProvider>()
                              .getDateReminder(Reminder.date);
                          LocalNotification.showScheduledNotification(
                              title: _name.text.trim(),
                              body: AppLocalizations.of(context)!.medTime,
                              timePresent: temp,
                              timeFuture: temp2);
                          Provider.of<DataProvider>(context, listen: false)
                              .getAllReminders();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
