import 'package:flutter/cupertino.dart';
import 'package:info_med/constants/drugs.dart';
import 'package:info_med/models/db_data.dart';
import 'package:intl/intl.dart';

import '../models/db_reminder.dart';
import 'package:info_med/util/database.dart';

class DataProvider with ChangeNotifier{
  int listIndex = 1;
  List<String> tempList=drugs;
  List<DbReminder> listReminder = [];
  List<DbReminder> listOfAllReminders = [];
  List<DbData> listFavored = [];
  databaseHelper db = databaseHelper.instance;

DataProvider(){
  getDataReminder(DateTime.now());
  getDataFavored();
}

updateChip(int index, List<String> temp) async {
   listIndex=index;
   tempList=temp;
   notifyListeners();
  }

getAllReminders()async{
   listOfAllReminders = await db.selectRemindersOrderByDate();
   notifyListeners();
  }

getDataReminder(DateTime date)async{
   listReminder = await db.selectRD(DateFormat('yyyy-MM-dd').format(date));
   getAllReminders();
   notifyListeners();
  }
getDataFavored()async{
   listFavored = await db.select();
   notifyListeners();
  }

}