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
  static const t_name = 'Medinfo';
  static const c_name = 'name';
  static const c_description = 'description';
  static const c_instruction = 'instruction';
  static const c_sideeffect = 'sideeffect';
  static const c_image = 'image';
  static const c_type = 'type';
   static const rt_name = 'Reminders';
  static const r_name = 'name';
  static const r_time = 'time';
  static const r_date = 'date';
  static const r_dose = 'dose';
  static const r_when = 'whent';
  static const r_image = 'image';
  static const r_type = 'type';

  databaseHelper._privateConstractor();
  static final databaseHelper instance = databaseHelper._privateConstractor();
  Database? _database;
  Database? _reminder;
  // Future<Database> get database async =>
  //     _database ??= _initilizdb() as Database;

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
    CREATE TABLE $t_name(
      $c_name TEXT PRIMARY KEY NOT NULL,
      $c_description TEXT NOT NULL,
      $c_instruction TEXT NOT NULL,
      $c_sideeffect TEXT NOT NULL,
      $c_image TEXT NOT NULL,
      $c_type TEXT NOT NULL
    )
''');
  }
   _onRcreate(Database? db, int version) async {
    await db!.execute('''
    CREATE TABLE $rt_name(
      $r_name TEXT NOT NULL,
      $r_dose INTEGER NOT NULL,
      $r_when TEXT NOT NULL,
      $r_date TEXT NOT NULL,
      $r_time TEXT NOT NULL,
      $r_image TEXT NOT NULL,
      $r_type TEXT NOT NULL,
      PRIMARY KEY ($r_name, $r_date)
    )
''');
  }

  Future<int> insert(Map<String, dynamic> json) async {
    Database? db = await instance.database;
    return await db!.insert(t_name, json).whenComplete(() => notifyListeners());
  }

  Future<List<DbData>> select() async {
    Database? db = await instance.database;
    var result = await db!.query(t_name, orderBy: c_name,);
    List<DbData> data =
        result.isNotEmpty ? result.map((e) => DbData.fromjson(e)).toList() : [];
    return data;
  }
  Future<int> delete(String name) async {
    Database? db = await instance.database;

    return await db!.delete(t_name,
        where: '$c_name=?',
        whereArgs: [name]).whenComplete(() => notifyListeners());
  }

  Future<int> insertR(Map<String, dynamic> json,DateTime time ) async {
    Database? db = await instance.reminder;
    DateTime timeNow=DateTime.now();
    if(timeNow.day <= time.day || timeNow.month <= time.month || timeNow.year <= time.year || timeNow.hour <= time.hour || timeNow.minute < time.minute){
    for(int i =timeNow.day;i<=time.day;i++){
      
      if(i==timeNow.day && timeNow.hour > time.hour || timeNow.minute > time.minute)
      {
        timeNow = DateTime(timeNow.year, timeNow.month, timeNow.day + 1);
      }
      else{
        json['date']=DateFormat('yyyy-MM-dd').format(timeNow);
        await db!.insert(rt_name, json).whenComplete(() => notifyListeners());
        timeNow = DateTime(timeNow.year, timeNow.month, timeNow.day + 1);

      }
    }
    }
    return 0;
    
  }

  Future<List<DbReminder>> selectRD(String date) async {
    Database? db = await instance.reminder;
    var result = await db!.query(rt_name,where: '$r_date=?' ,
        whereArgs: [date]);
    List<DbReminder> data =
        result.isNotEmpty ? result.map((e) => DbReminder.fromjson(e)).toList() : [];
    return data;
  }


  Future<int> deleteR(String name,String date) async {
    Database? db = await instance.reminder;

    return await db!.delete(rt_name,
        where: '$r_name=? AND $r_date=?',
        whereArgs: [name,date]).whenComplete(() => notifyListeners());
  }
}
