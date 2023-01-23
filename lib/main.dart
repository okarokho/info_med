import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:info_med/models/drugs.dart';
import 'package:info_med/models/image.dart';
import 'package:info_med/models/second_api.dart';
import 'package:info_med/services/database.dart';
import 'package:info_med/pages/home.dart';
import 'package:info_med/services/provider.dart';
import 'package:info_med/services/shared_preference.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

String kurdishDB='drug.hive';
String arabicDB='drugs.hive';
String englishDB='druges.hive';
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
final directory = await getApplicationDocumentsDirectory();
final fileKurdish = File('${directory.path}/$kurdishDB');
final fileEnglish = File('${directory.path}/$englishDB');
final fileArabic = File('${directory.path}/$arabicDB');

existk() async {
 return  await fileKurdish.exists();
}
exista() async {
 return  await fileArabic.exists();
}
existe() async {
 return  await fileEnglish.exists();
}

final result = await Future.wait([existk(),exista(),existe()]);
final kexists = result[0];
final aexists = result[1];
final eexists = result[2];

if (!kexists) {
  final data = await rootBundle.load('assets/data/$kurdishDB');
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await fileKurdish.writeAsBytes(bytes, flush: true);
}
if (!aexists) {
  final data = await rootBundle.load('assets/data/$arabicDB');
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await fileArabic.writeAsBytes(bytes, flush: true);
}
if (!eexists) {
  final data = await rootBundle.load('assets/data/$englishDB');
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await fileEnglish.writeAsBytes(bytes, flush: true);
}

  await Hive.openBox<Drugs>('drugs');
  await Hive.openBox<Drugs>('drug');
  await Hive.openBox<Drugs>('druges');

  Img();

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
        ChangeNotifierProvider(
          create: (context) => Get(),
        ),
      ],
      child: Consumer<SharedPreference>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MedScan',
            theme: ThemeData(primarySwatch: Colors.deepPurple),
            home: Home(),
          );
        },
      ),
    );
  }
}
