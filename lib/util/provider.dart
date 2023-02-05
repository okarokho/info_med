import 'package:flutter/cupertino.dart';
import 'package:info_med/models/db_data.dart';
import 'package:intl/intl.dart';

import '../models/db_reminder.dart';
import 'package:info_med/util/database.dart';

class DataProvider with ChangeNotifier{
  List<DbReminder> listReminder = [];
  List<DbData> listFavored = [];
  var db = databaseHelper.instance;

DataProvider(){
  getDataReminder(DateTime.now());
  getDataFavored();
}
  getDataReminder(DateTime date)async{
   listReminder = await db.selectRD(DateFormat('yyyy-MM-dd').format(date));
   notifyListeners();
  }
   getDataFavored()async{
   listFavored = await db.select();
   notifyListeners();
  }

}