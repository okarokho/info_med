import 'package:flutter/cupertino.dart';
import 'package:info_med/constants/drugs.dart';
import 'package:info_med/models/sql/db_data.dart';
import 'package:intl/intl.dart';
import '../../models/sql/db_reminder.dart';
import 'package:info_med/util/database/database.dart';

class DataProvider with ChangeNotifier {
  // page index
  int listIndex = 1;
  // list of drug by category
  List<String> tempList = drugs;
  // list of reminder drugs by date
  List<DbReminder> listReminder = [];
  // list of all reminder drugs
  List<DbReminder> listOfAllReminders = [];
  // list of favoured drug
  List<DbData> listFavored = [];
  // an instance of database
  DatabaseHelper db = DatabaseHelper.instance;

// get the list of favoured drugs and reminder drugs
  DataProvider() {
    getDateReminder(DateTime.now());
    getDataFavored();
  }

// update categories
  updateChip(int index, List<String> temp) async {
    listIndex = index;
    tempList = temp;
    notifyListeners();
  }

// get all reminder drugs
  getAllReminders() async {
    listOfAllReminders = await db.selectAllRemindersOrderByDate();
    notifyListeners();
  }

// get all reminder drug in specific date
  getDateReminder(
    DateTime date,
  ) async {
    listReminder = await db
        .selectReminderByDate(DateFormat('yyyy-MM-dd', 'ku').format(date));
    getAllReminders();
    notifyListeners();
  }

// get all favoured drugs

  getDataFavored() async {
    listFavored = await db.selectSaved();
    notifyListeners();
  }
}
