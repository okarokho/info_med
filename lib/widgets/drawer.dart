
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/image.dart';
import '../services/shared_preference.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final theme = SharedPreference();
  Image? image;
List<String> listOfLang = ['کوردی','English','عربي'];
  @override
  void initState() {
    super.initState();
    image = Img.image;
  }




  @override
  Widget build(BuildContext context) {
    return Drawer(
      
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(70), bottomRight: Radius.circular(20)),
      ),
      child: Column(children: [
        SizedBox(
          height: 203,
          child: ClipRRect(
            borderRadius:
                const BorderRadius.only(topRight: Radius.circular(20)),
            child: image ,
          ),
        ),
        /*Consumer<SharedPreference>(
          builder: (context, value, child) => ListTile(
              horizontalTitleGap: 90.0,
              leading: value.darkTheme
                  ? const Icon(Icons.dark_mode_outlined, color: Colors.black)
                  : const Icon(
                      Icons.dark_mode,
                      color: Colors.black,
                    ),
              trailing: Transform.scale(
                scale: 1.2,
                child: Switch.adaptive(
                  value: value.darkTheme,
                  activeColor: Colors.blue,
                  onChanged: (newvalue) {
                    setState(() {
                      value.toggleTheme();
                    });
                  },
                ),
              )),
        ),*/
        const SizedBox(height: 20,),
         Consumer<SharedPreference>(
          builder: (context, language, child) {
            return ListTile(
            horizontalTitleGap: 80.0,
            leading: const Icon(Icons.language_rounded,size: 40 ,color: Color( 0xff8F00FF)),
            title: Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Container(
                              height: 64,
                              decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0)),
                              child: DropdownButtonFormField(
                              decoration: InputDecoration(
                              labelText:language.language == 'Kurdish' ? 'زمان' : language.language == 'Arabic' ? 'لغة' : 'Language',
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                                    value: language.language == 'Kurdish' ? 'کوردی' : language.language == 'Arabic' ? 'عربي' : 'English',
                                    borderRadius: BorderRadius.circular(12),
                                    isExpanded: true,
                                    onChanged: (value) {
                                            setState(() {
                                               language.setLanguage(value == 'کوردی' ? 'Kurdish' : value == 'English' ? 'English' : 'Arabic');});},
                                    onSaved: (value) {
                                                 setState(() {
                                               language.setLanguage(value == 'کوردی' ? 'Kurdish' : value == 'English' ? 'English' : 'Arabic');});
                                               },
                                    
                                    items: listOfLang.map((String val) {
                                            return DropdownMenuItem(
                                              value: val,
                                              child: Text(val),);}).toList(),
                   )
                            ),
                      ),
                 );
          }
         ),
      ]),
    );
  }
}
