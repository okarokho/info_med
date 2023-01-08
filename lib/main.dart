import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:info_med/models/drugs.dart';
import 'package:info_med/services/database.dart';
import 'package:info_med/pages/home.dart';
import 'package:info_med/services/provider.dart';
import 'package:info_med/services/shared_preference.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

String kurdishDB='drugs.hive';
String arabicDB='drugs_arabic.hive';
String englishDB='drugs_english.hive';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  AwesomeNotifications().initialize(null, 
  [
    NotificationChannel(channelKey: 'key1', channelName: 'medication', channelDescription: 'take_med',
     enableLights: true,
     playSound: true,
     enableVibration: true,
     ledColor: Colors.white,
     soundSource: 'resource://raw/res_custom_notification',
     importance: NotificationImportance.Max),
     
  ]
  );
  
  Hive.registerAdapter(DrugsAdapter());
  //  Hive.registerAdapter(DrugsArabicAdapter());
  //   Hive.registerAdapter(DrugsEnglishAdapter());
final directory = await getApplicationDocumentsDirectory();
final fileKurdish = File('${directory.path}/$kurdishDB');
final fileEnglish = File('${directory.path}/$englishDB');
final fileArabic = File('${directory.path}/$arabicDB');
final kexists = await fileKurdish.exists();
final aexists = await fileArabic.exists();
final eexists = await fileEnglish.exists();
if (!kexists) {
  final data = await rootBundle.load('assets/data/drugs.hive');
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await fileKurdish.writeAsBytes(bytes, flush: true);
}
if (!eexists) {
  final data = await rootBundle.load('assets/data/drugs_english.hive');
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await fileEnglish.writeAsBytes(bytes, flush: true);
}
if (!aexists) {
  final data = await rootBundle.load('assets/data/drugs_arabic.hive');
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await fileArabic.writeAsBytes(bytes, flush: true);
}

  await Hive.openBox<Drugs>('drugs');
  await Hive.openBox<Drugs>('drugs_english');
  await Hive.openBox<Drugs>('drugs_arabic');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.bottom]);
     SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SharedPreference(),
        ),
        ChangeNotifierProvider(
          create: (context) => databaseHelper.instance,
        ),
        ChangeNotifierProvider(
          create: (context) => DataProvider(),
        ),
      ],
      child: Consumer<SharedPreference>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'InfoMed',
            theme: ThemeData(primarySwatch: Colors.deepPurple),
            home: Home(),
          );
        },
      ),
    );
  }
}
