import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:info_med/models/sql/db_data.dart';
import 'package:info_med/models/sql/db_reminder.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as j;

class DatabaseHelper with ChangeNotifier {
  // database & table name with column
  final String _databaseName = 'drug.db';
  final int _version = 1;
  final String _savedTableName = 'info';
  final String _savedName = 'name';
  final String _savedDescription = 'description';
  final String _savedInstruction = 'instruction';
  final String _savedSideeffect = 'sideeffect';
  final String _savedImage = 'image';
  final String _savedType = 'type';
  final String _reminderTableName = 'reminders';
  final String _reminderName = 'name';
  final String _reminderTimeFuture = 'timeFuture';
  final String _reminderTimePresent = 'timePresent';
  final String _reminderDate = 'date';
  final String _reminderDose = 'dose';
  final String _reminderWhen = 'whent';
  final String _reminderImage = 'image';
  final String _reminderType = 'type';
  Database? _saved;

  // get an instance of database
  DatabaseHelper._privateConstractor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstractor();

  // initialize database if not exist
  Future<Database?> get saved async {
    if (_saved != null) {
      return _saved;
    } else {
      _saved = await _initilizSavedDB();
      return _saved;
    }
  }

  // create path for database
  Future<Database> _initilizSavedDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = j.join(dir.path, _databaseName);
    return await openDatabase(path,
        version: _version, onCreate: _oncreateSaved);
  }

  // create tables
  _oncreateSaved(Database? db, int version) async {
    await db!.execute('''
    CREATE TABLE $_savedTableName(
      $_savedName TEXT PRIMARY KEY NOT NULL,
      $_savedDescription TEXT NOT NULL,
      $_savedInstruction TEXT NOT NULL,
      $_savedSideeffect TEXT NOT NULL,
      $_savedImage TEXT NOT NULL,
      $_savedType TEXT NOT NULL
    )
''');

    await db.execute('''
    CREATE TABLE $_reminderTableName(
      $_reminderName TEXT NOT NULL,
      $_reminderDose INTEGER NOT NULL,
      $_reminderWhen TEXT NOT NULL,
      $_reminderDate TEXT NOT NULL,
      $_reminderTimeFuture TEXT NOT NULL,
      $_reminderTimePresent TEXT NOT NULL,
      $_reminderImage TEXT NOT NULL,
      $_reminderType TEXT NOT NULL,
      PRIMARY KEY ($_reminderName, $_reminderDate)
    )
''');
  }

  Future<int> insertSaved(Map<String, dynamic> json) async {
    Database? db = await instance.saved;
    return await db!
        .insert(_savedTableName, json)
        .whenComplete(() => notifyListeners());
  }

  Future<List<DbData>> selectSaved() async {
    Database? db = await instance.saved;
    var result = await db!.query(
      _savedTableName,
      orderBy: _savedName,
    );
    List<DbData> data =
        result.isNotEmpty ? result.map((e) => DbData.fromjson(e)).toList() : [];
    return data;
  }

  Future<int> deleteSaved(String name) async {
    Database? db = await instance.saved;

    return await db!.delete(_savedTableName,
        where: '$_savedName=?',
        whereArgs: [name]).whenComplete(() => notifyListeners());
  }

  Future<int> insertReminder(Map<String, dynamic> json, DateTime timeFuture,
      DateTime timePresent) async {
    Database? db = await instance.saved;

    while (timePresent.compareTo(timeFuture) < 0) {
      json['date'] = DateFormat('yyyy-MM-dd').format(timePresent);
      await db!
          .insert(_reminderTableName, json)
          .whenComplete(() => notifyListeners());
      timePresent = DateTime(timePresent.year, timePresent.month,
          timePresent.day + 1, timePresent.hour, timePresent.minute);
    }
    return 0;
  }

  Future<List<DbReminder>> selectReminderByDate(String date) async {
    Database? db = await instance.saved;
    var result = await db!.query(_reminderTableName,
        where: '$_reminderDate=?', whereArgs: [date]);
    List<DbReminder> data = result.isNotEmpty
        ? result.map((e) => DbReminder.fromjson(e)).toList()
        : [];
    return data;
  }

  Future<List<DbReminder>> selectAllRemindersOrderByDate() async {
    Database? db = await instance.saved;
    var result = await db!.query(
      _reminderTableName,
      orderBy: _reminderDate,
    );
    List<DbReminder> data = result.isNotEmpty
        ? result.map((e) => DbReminder.fromjson(e)).toList()
        : [];
    return data;
  }

  Future<int> deleteReminder(String name, String date) async {
    Database? db = await instance.saved;

    return await db!.delete(_reminderTableName,
        where: '$_reminderName=? AND $_reminderDate=?',
        whereArgs: [name, date]).whenComplete(() => notifyListeners());
  }
}
