// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:info_med/pages/main%20screen/mainscreen.dart';
import 'package:info_med/pages/reminder/reminder.dart';
import 'package:info_med/pages/saved/saved.dart';
import 'package:info_med/pages/tracking/tracker.dart';
import 'package:info_med/widgets/scaffold/appbar.dart';
import 'package:info_med/widgets/scaffold/custom_fab.dart';
import 'package:info_med/widgets/scaffold/drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../util/provider/shared_preference.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget with ChangeNotifier {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: false,
        drawer: const MyDrawer(),
        appBar: const MyAppBar(),
        floatingActionButton: const MyFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar:
            // navigation bar
            ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
          child: SizedBox(
            height: 80,
            child: Consumer<SharedPreference>(
              builder: (context, value, child) => BottomNavigationBar(
                  elevation: 10,
                  backgroundColor: Colors.grey[00],
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  selectedItemColor:
                      value.darkTheme ? Colors.white : const Color(0xff8F00FF),
                  unselectedItemColor:
                      value.darkTheme ? Colors.white : Colors.grey,
                  unselectedFontSize: 12,
                  selectedFontSize: 12,
                  items: [
                    // main
                    BottomNavigationBarItem(
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                          icon: Icon(
                            _currentIndex == 0
                                ? Icons.home_rounded
                                : Icons.home_outlined,
                            size: 35,
                          ),
                        ),
                        label: AppLocalizations.of(context)!.home),
                    // saved
                    BottomNavigationBarItem(
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          icon: Icon(
                              _currentIndex == 1
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline_rounded,
                              size: 35),
                        ),
                        label: AppLocalizations.of(context)!.saved),
                    // blank
                    const BottomNavigationBarItem(
                        icon: IconButton(
                          icon: Icon(
                            Icons.expand_more_rounded,
                            color: Colors.transparent,
                            size: 10,
                          ),
                          onPressed: null,
                        ),
                        label: ''),
                    // tracking
                    BottomNavigationBarItem(
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 3;
                            });
                          },
                          icon: Icon(
                              _currentIndex == 3
                                  ? Icons.timeline_rounded
                                  : Icons.timeline_rounded,
                              size: 35),
                        ),
                        label: AppLocalizations.of(context)!.tracking),
                    // reminder
                    BottomNavigationBarItem(
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 4;
                            });
                          },
                          icon: Icon(
                              _currentIndex == 4
                                  ? Icons.access_time_filled_rounded
                                  : Icons.access_time_rounded,
                              size: 35),
                        ),
                        label: AppLocalizations.of(context)!.reminder),
                  ]),
            ),
          ),
        ),
        body: _currentIndex == 0
            ? Main()
            : _currentIndex == 1
                ? const Saved()
                : _currentIndex == 3
                    ? const Tracking()
                    : const Reminder(),
      ),
    );
  }
}
