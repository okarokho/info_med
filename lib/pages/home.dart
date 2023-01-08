// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:info_med/pages/mainscreen.dart';
import 'package:info_med/pages/reminder.dart';
import 'package:info_med/pages/saved.dart';
import 'package:info_med/pages/tracker.dart';
import 'package:info_med/widgets/appbar.dart';
import 'package:info_med/widgets/custom_fab.dart';
import 'package:info_med/widgets/drawer.dart';
import 'package:provider/provider.dart';

import '../services/shared_preference.dart';


// ignore: must_be_immutable
class Home extends StatefulWidget with ChangeNotifier {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      // Color(0xffeeeeee)
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: false,
      drawer: const MyDrawer(),
      appBar: const MyAppBar(),
      floatingActionButton:const MyFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
      
      
       ClipRRect(
        borderRadius:  const BorderRadius.only(
        topRight: Radius.circular(12),
        topLeft: Radius.circular(12),
      ),
         child: SizedBox(
          height: 74,
           child: BottomNavigationBar(
              elevation:10,
              
              backgroundColor: Colors.grey[100],
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              selectedItemColor:
                  Provider.of<SharedPreference>(context).darkTheme
                      ? Colors.white
                      : const Color( 0xff8F00FF),
              unselectedItemColor:
                  Provider.of<SharedPreference>(context).darkTheme
                      ? Colors.white
                      : Colors.grey,
              unselectedFontSize: 12,
              selectedFontSize: 12,

              items: [
                BottomNavigationBarItem(
                  
                    activeIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.home_rounded,
                          size: 35,
                        )),
                    icon: IconButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 0;
                        });
                      },
                      icon: const Icon(Icons.home_outlined, size: 35),
                    ),
                    label: 'Home'),
                      BottomNavigationBarItem(
                    activeIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_rounded, size: 35)),
                    icon: IconButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                      icon:
                          const Icon(Icons.favorite_outline_rounded, size: 35),
                    ),
                    label: 'Saved'),
                     
                const BottomNavigationBarItem(

                    icon: Icon(
                      
                        Icons.expand_more_rounded,
                        color: Colors.transparent,
                        size: 10,
                      ),
                    label: ''),
              
                    BottomNavigationBarItem(
                    activeIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.timeline_rounded,
                          size: 35,
                        )),
                    icon: IconButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 3;
                        });
                      },
                      icon: const Icon(Icons.timeline_rounded, size: 35),
                    ),
                    label: 'Tracking'),
                    BottomNavigationBarItem(
                    activeIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.access_time_filled_rounded, size: 35)),
                    icon: IconButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 4;
                        });
                      },
                      icon:
                          const Icon(Icons.access_time_rounded, size: 35),
                    ),
                    label: 'Reminder'),
                    
              ]),
         ),
       ),
      body: currentIndex == 0 ? Main() : currentIndex == 1 ? const Saved() :  currentIndex == 3 ? const Tracking() :  Reminder(),
    );
    
  }
}
