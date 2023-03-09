import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:info_med/models/hive/drug.dart';
import 'package:info_med/util/image%20compression/image.dart';
import 'package:info_med/models/api/second_api.dart';
import 'package:info_med/util/database/database.dart';
import 'package:info_med/pages/home/home.dart';
import 'package:info_med/util/provider/provider.dart';
import 'package:info_med/util/provider/shared_preference.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'l10n/l10n.dart';
import 'util/kurdish localization/calender_localization.dart';
import 'package:info_med/util/kurdish%20localization/kurdish_localization.dart';

String _database = 'drugs.hive';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // create notification channel
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'key1',
        channelName: 'medication',
        channelDescription: 'take_med',
        enableLights: true,
        playSound: true,
        enableVibration: true,
        ledColor: Colors.white,
        soundSource: 'resource://raw/res_custom_notification',
        importance: NotificationImportance.Max),
  ]);

  // initialize hive
  await Hive.initFlutter();

  // register class adapter
  Hive.registerAdapter(DrugsAdapter());

  // get directory for database
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$_database');

  // check if database exist
  final result = await file.exists();

  // if not exist then initialize
  if (!result) {
    final data = await rootBundle.load('assets/data/$_database');
    final bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await file.writeAsBytes(bytes, flush: true);
  }

  // open hive box
  await Hive.openBox<Drugs>('drugs');

  // compress the default image
  Img();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // setting the orientation only to portraite
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // add all necessary providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SharedPreference(),
        ),
        ChangeNotifierProvider(
          create: (context) => DatabaseHelper.instance,
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
            locale: value.language,
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              KuCupertinoLocalizations.delegate,
              KuMaterialLocalizations.delegate,
              SfGlobalLocalizations.delegate,
              SfLocalizationsKuDelegate()
            ],
            theme: ThemeData(primarySwatch: Colors.deepPurple),
            builder: (context, child) => Directionality(
                textDirection: value.language != L10n.all[0]
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Builder(
                  builder: (context) => child!,
                )),
            home: Home(),
          );
        },
      ),
    );
  }
}
