import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:info_med/models/db_reminder.dart';
import 'package:info_med/services/database.dart';
import 'package:info_med/services/provider.dart';
import 'package:info_med/services/shared_preference.dart';
import 'package:info_med/widgets/my_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/notification.dart';

// ignore: must_be_immutable
class Reminder extends StatefulWidget {
   Reminder({super.key});
List<String> images = [
  'assets/list/capsule.png',
  // 'assets/list/cream.png',
  // 'assets/list/drops.png',
  'assets/list/pills.png',
  'assets/list/syringe.png',
  'assets/list/syrup.png',
];
List<String> labelsEnglish = [
  'Capsule',
  // 'Cream',
  // 'Drops',
  'Pills',
  'Syringe',
  'Syrup',
];
List<String> labelsKurdish = [
  'کەپسول',
  // 'Cream',
  // 'Drops',
  'حەب',
  'سرنج',
  'شروب',
];
List<String> labelsArabic = [
  'کبسولة',
  // 'Cream',
  // 'Drops',
  'حبة',
  'محقنة',
  'شراب',
];
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
        Container(
          color: Colors.white,
        ),
        SafeArea(
          child: Column(
            children: [
              Container(
            width: 345,
            margin: const EdgeInsets.symmetric( horizontal: 23,vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: DatePicker(
          DateTime.now(),
          height: 90,
          width: 80,
          onDateChange: (selectedDate) => setState(() {
            Reminder.date=selectedDate;
            context.read<DataProvider>().getDataReminder(selectedDate);
          }),
          initialSelectedDate: DateTime.now(),
          selectionColor:const Color( 0xff8F00FF),
          selectedTextColor: Colors.white,
          daysCount: 31,
          dateTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
                ),
            ),),
            Expanded(
              child: Consumer2<DataProvider,SharedPreference>(
                builder: (context,data,value,child) {
                return data.listReminder.isNotEmpty? ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.listReminder.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.white,
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
                                const Icon(Icons.timer,color: Color( 0xff8F00FF),),
                                Text(DateFormat('h:mm a').format(data.listReminder[index].time!))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },)
              :  Center(child: TitleText(txt: value.language == 'Kurdish' ?'هیچ دەرمانێکت نییە بۆ بیرخستنەوە !!':value.language == 'Arabic' ?'لا دواء للتذكير !!':'No Drug to Remind !!',size: 20,ltr: value.language == 'English'?true:false),);
                },),
            )
            


            
            ],
          )
        ),
        SafeArea(
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(onPressed: () => showModalBottomSheet(
              isDismissible: false,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            context: context, 
            builder: (context) {
              final language = context.watch<SharedPreference>().language;
               return AddMedicine(img: widget.images,lbl:language == 'Kurdish'?widget.labelsKurdish:language == 'Arabic'?widget.labelsArabic:widget.labelsEnglish,language: language);
            },),
          backgroundColor: Colors.white,
          elevation: 10,
          child: const Icon(Icons.add_alert_rounded,color:Color( 0xff8F00FF),size: 33,),
          
          )),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class AddMedicine extends StatefulWidget {
   AddMedicine({
    Key? key,
    required this.img,
    required this.lbl,
    required this.language
  }) : super(key: key);
List<String> img;
List<String> lbl;
String language;
  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
String? type;
String? time;
List<String> listOfTypeEnglish = ['Tabs','Capsule', 'mg', 'ml','cc'];
List<String> listOfTypeArabic = ['Tabs','کبسولة', 'ملغ', 'ملل','cc'];
List<String> listOfTypeKurdish = ['Tabs','کەپسول', 'ملگ', 'ملل','cc'];
late List<String> listOfTypeTemp;

List<String> listOfTimeEnglish = ['After meal','With meal','Before meal'];
List<String> listOfTimeArabic= ['بعد الوجبات','مع الوجبات','قبل الوجبات'];
List<String> listOfTimeKurdish = ['دوای نان','لەگەڵ نان','پێش نان'];
late List<String> listOfTimeTemp;

late TextEditingController name;
late TextEditingController dose;
int isSelected = 0;
DateTime? pickedDate;
TimeOfDay? pickedTime;
bool flage=false;
bool flage2=false;
@override
  void initState() {
  listOfTypeTemp = widget.language == 'Kurdish'?listOfTypeKurdish:widget.language == 'Arabic'?listOfTypeArabic:listOfTypeEnglish;
  listOfTimeTemp = widget.language == 'Kurdish'?listOfTimeKurdish:widget.language == 'Arabic'?listOfTimeArabic:listOfTimeEnglish;
  name= TextEditingController();
  dose= TextEditingController();
    super.initState();
  }
@override
  void dispose() {
      name.dispose();
      dose.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return DraggableScrollableSheet(

      initialChildSize: 0.755,
      minChildSize: 0.3,
      maxChildSize: 0.755,
      
      builder: (context, scrollController) => ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 26.0,horizontal: 30),
                  child: SizedBox(
                    height: 115,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.img.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => GestureDetector(
                         onTap: () => setState(() {
                                      isSelected=index;
                                      }),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8,top: 8),
                          child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Container(
                                          color:  isSelected == index ?Colors.grey[300]:Colors.white,
                                          height: 80.0,
                                          width: 80.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(

                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                index==3?Image.asset(widget.img[index],height: 74.9,width: 60,):Image.asset(widget.img[index],),
                                                Baseline(baseline: 15, 
                                         baselineType: TextBaseline.alphabetic,
                                         child: Text(widget.lbl[index]),)
                                              ],
                                            ),
                                          ),
                                             ),
                                              ),
                        ),
                      ),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 10,right: 35,left: 35),
                  child: Container(
                        height: 59,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0)),
                        child: TextField(
                          maxLines: 1,
                          decoration:  InputDecoration(
                            labelText: widget.language == 'Kurdish' ?'ناوی دەرمان':widget.language == 'Arabic' ?'اسم الطب':'Drug Name',
                            
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              
                            ),
                          ),
                          controller: name,
                         
                        ),
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                            height: 59,
                            width: 143,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0)),
                            child: TextField(
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              decoration:  InputDecoration(
                                labelText: widget.language == 'Kurdish' ?'ژەمە دەرمان':widget.language == 'Arabic' ?'جرعة دواء':'Dose',
                                
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  
                                ),
                              ),
                              controller: dose,
                             
                            ),
                          ),
                    ),
                     Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                            height: 59,
                            width: 143,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0)),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                            labelText:widget.language == 'Kurdish' ?'جۆر':widget.language == 'Arabic' ?'نوع':'Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), 
                            ),
                          ),
                                  value: type,
                                  borderRadius: BorderRadius.circular(12),
                                  isExpanded: true,
                                  onChanged: (value) {
                                          setState(() {
                                              type = value;});},
                                  onSaved: (value) {
                                          setState(() {
                                              type = value;});},
                                  validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "can't empty";
                                          } else {
                                            return null;}},
                                  items: listOfTypeTemp.map((String val) {
                                          return DropdownMenuItem(
                                            value: val,
                                            child: Text(val,),);}).toList(),
                 )
                          ),
                    ),
                    
                  ],
                ),
                Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 35),
                      child: Container(
                            height: 59,
                            
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0)),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                            labelText:widget.language == 'Kurdish' ?'کاتی وەرگرتن':widget.language == 'Arabic' ?'الوقت لآخذ':'When to take',
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
                                              time = value;});},
                                  onSaved: (value) {
                                          setState(() {
                                              time = value;});},
                                  validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return widget.language == 'Kurdish' ?'کات دیاری نەکراوە':widget.language == 'Arabic' ?'انها فارغة':"can't empty";
                                          } else {
                                            return null;}},
                                  items: listOfTimeTemp.map((String val) {
                                          return DropdownMenuItem(
                                            value: val,
                                            child: Text(val,),);}).toList(),
                 )
                          ),
                    ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                      Container(
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                                              color: Colors.grey[300],

                          ),
                          child: GestureDetector(
                            onTap: () async{
                              final test = await showTimePicker(context: context,
                            errorInvalidText: widget.language == 'Kurdish' ?'کاتەکە هەڵەیە':widget.language == 'Arabic' ?'الوقت غیر صحیح':'Invalid Format',
                            initialTime: TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.dialOnly
                            
                             );
                               setState(() {
                                if(test!=null)flage2=true;
                             pickedTime = test;
                            });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                               
                                Text(
                                  flage2 == true? TimeOfDay(hour:pickedTime!.hour ,minute: pickedTime!.minute).format(context):widget.language == 'Kurdish' ?'بەتاڵ':widget.language == 'Arabic' ?'فارغ':'No Time',
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,),
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
                        const SizedBox(width: 10,),
                       Container(
                              height: 50,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                                  color: Colors.grey[300],

                              ),
                              child: GestureDetector(
                                onTap: () async{
                                  final test = await showDatePicker(context: context,
                                errorInvalidText: widget.language == 'Kurdish' ?'بەروارەکە هەڵەیە':widget.language == 'Arabic' ?'التاریخ غیر صحیح':'Invalid Format',
                                 initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year+9));
                                   setState(() {
                                  if(test !=null)flage=true;
                                 pickedDate = test;
                                });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                   
                                    Text(
                                      flage == true?DateFormat("dd.MM").format(pickedDate!):widget.language == 'Kurdish' ?'بەتاڵ':widget.language == 'Arabic' ?'فارغ':'No Date',
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,),
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
                Consumer<databaseHelper>(
                  builder: (context, value, child) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 40),
                    child: ElevatedButton(onPressed: () {
                          final temp = DateTime(pickedDate!.year, pickedDate!.month, pickedDate!.day, pickedTime!.hour, pickedTime!.minute);

                        var test = DbReminder(
                                                  name: name.text.trim(),
                                                  date: DateFormat('yyyy-MM-dd').format(pickedDate!),
                                                  time: temp,
                                                  dose: int.parse(dose.text),
                                                  when: time,
                                                  image:widget.img[ isSelected] ,
                                                  type: type);
                                           
                                              value.insertR(test.tojson(),temp);
                                              context.read<DataProvider>().getDataReminder(Reminder.date);
                                               LocalNotification.showScheduledNotification(
                                               title: name.text.trim(),
                                               body: widget.language == 'Kurdish' ?'! کاتی وەرگرتنی دەرمانەکەتە':widget.language == 'Arabic' ?'! الوقت الاتخاذ الدواء':'Time to take your Medication !',
                                               timeFuture: temp);
                                               Navigator.of(context).pop();
                    },                          
                    style:  ElevatedButton.styleFrom(
                        
                          fixedSize:const Size(400,40) 
                    ),
                     child: Text(widget.language == 'Kurdish' ?'خەزن بکە':widget.language == 'Arabic' ?'حفظ':'Save',style: const TextStyle(fontSize: 18),)),
                  ),
                )

              ],
            ),
          ),
        ),
      ),);
  }
}