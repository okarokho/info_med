// ignore_for_file: constant_identifier_names, camel_case_types

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:info_med/models/db_data.dart';
import 'package:info_med/models/db_reminder.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as j;

class databaseHelper with ChangeNotifier {
  static const _dbname = 'drug.db';
  static const _rdbname = 'reminder.db';
  static const _version = 1;
  static const _t_name = 'Medinfo';
  static const _c_name = 'name';
  static const _c_description = 'description';
  static const _c_instruction = 'instruction';
  static const _c_sideeffect = 'sideeffect';
  static const _c_image = 'image';
  static const _c_type = 'type';
  static const _c_language = 'language';
  static const _rt_name = 'Reminders';
  static const _r_name = 'name';
  static const _r_timeFuture = 'timeFuture';
  static const _r_timePresent = 'timePresent';
  static const _r_date = 'date';
  static const _r_dose = 'dose';
  static const _r_when = 'whent';
  static const _r_image = 'image';
  static const _r_type = 'type';

  databaseHelper._privateConstractor();
  static final databaseHelper instance = databaseHelper._privateConstractor();
  Database? _database;
  Database? _reminder;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initilizdb();
      return _database;
    }
  
  }
    Future<Database?> get reminder async {
   
  if (_reminder != null) {
      return _reminder;
    } else {
      _reminder = await _initilizRdb();
      return _reminder;
    }
  }

  Future<Database> _initilizdb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = j.join(dir.path, _dbname);
    return await openDatabase(path, version: _version, onCreate: _oncreate);
  }
   Future<Database> _initilizRdb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = j.join(dir.path, _rdbname);
    return await openDatabase(path, version: _version, onCreate: _onRcreate);
  }

  _oncreate(Database? db, int version) async {
    await db!.execute('''
    CREATE TABLE $_t_name(
      $_c_name TEXT PRIMARY KEY NOT NULL,
      $_c_description TEXT NOT NULL,
      $_c_instruction TEXT NOT NULL,
      $_c_sideeffect TEXT NOT NULL,
      $_c_image TEXT NOT NULL,
      $_c_type TEXT NOT NULL,
      $_c_language TEXT NOT NULL
    )
''');
  }
   _onRcreate(Database? db, int version) async {
    await db!.execute('''
    CREATE TABLE $_rt_name(
      $_r_name TEXT NOT NULL,
      $_r_dose INTEGER NOT NULL,
      $_r_when TEXT NOT NULL,
      $_r_date TEXT NOT NULL,
      $_r_timeFuture TEXT NOT NULL,
      $_r_timePresent TEXT NOT NULL,
      $_r_image TEXT NOT NULL,
      $_r_type TEXT NOT NULL,
      PRIMARY KEY ($_r_name, $_r_date)
    )
''');
  }

  Future<int> insert(Map<String, dynamic> json) async {
    Database? db = await instance.database;
    return await db!.insert(_t_name, json).whenComplete(() => notifyListeners());
  }

  Future<List<DbData>> select() async {
    Database? db = await instance.database;
    var result = await db!.query(_t_name, orderBy: _c_name,);
    List<DbData> data =
        result.isNotEmpty ? result.map((e) => DbData.fromjson(e)).toList() : [];
    return data;
  }
 
  Future<int> delete(String name) async {
    Database? db = await instance.database;

    return await db!.delete(_t_name,
        where: '$_c_name=?',
        whereArgs: [name]).whenComplete(() => notifyListeners());
  }

  Future<int> insertR(Map<String, dynamic> json,DateTime timeFuture, DateTime timePresent ) async {
    Database? db = await instance.reminder;
    
  while(timePresent.compareTo(timeFuture) < 1) {

    if(timePresent.compareTo(timeFuture) == 0 ) {
      timePresent = DateTime(timePresent.year,timePresent.month,timePresent.day+1,timePresent.hour,timePresent.minute);
    } else { 
      json['date']=DateFormat('yyyy-MM-dd').format(timePresent);
      await db!.insert(_rt_name, json).whenComplete(() => notifyListeners());
      timePresent = DateTime(timePresent.year,timePresent.month,timePresent.day+1,timePresent.hour,timePresent.minute);
      }
    }
    return 0;
  }

  Future<List<DbReminder>> selectRD(String date) async {
    Database? db = await instance.reminder;
    var result = await db!.query(_rt_name,where: '$_r_date=?' ,
        whereArgs: [date]);
    List<DbReminder> data =
        result.isNotEmpty ? result.map((e) => DbReminder.fromjson(e)).toList() : [];
    return data;
  }

  Future<List<DbReminder>> selectRemindersOrderByDate() async {
    Database? db = await instance.reminder;
    var result = await db!.query(_rt_name,orderBy: _r_date,);
    List<DbReminder> data =
        result.isNotEmpty ? result.map((e) => DbReminder.fromjson(e)).toList() : [];
    return data;
  }


  Future<int> deleteR(String name,String date) async {
    Database? db = await instance.reminder;

    return await db!.delete(_rt_name,
        where: '$_r_name=? AND $_r_date=?',
        whereArgs: [name,date]).whenComplete(() => notifyListeners());
  }
}
