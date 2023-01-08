import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/shared_preference.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final theme = SharedPreference();
  Image? image;
List<String> listOfLang = ['Kurdish','English','Arabic'];
  @override
  void initState() {
    super.initState();
    image = Image.network(
        'https://media.istockphoto.com/photos/many-colorful-pills-and-capsules-spilling-on-blue-background-picture-id1333744874?k=20&m=1333744874&s=612x612&w=0&h=BxZjGZDFhnGCAYpw3Ydui-HuUrXK56utmfH6jFXEiuw=');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(70), bottomRight: Radius.circular(70)),
      ),
      child: Column(children: [
        Stack(
          children: [
            SizedBox(
              height: 203,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.only(topRight: Radius.circular(70)),
                child: image ,
              ),
            ),
            const Positioned(
              left: 90,
              top: 165,
              child: Center(
                child: Text("hi"),
              ),
            )
          ],
        ),
        Consumer<SharedPreference>(
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
        ),
         Consumer<SharedPreference>(
          builder: (context, language, child) => ListTile(
            horizontalTitleGap: 80.0,
            leading: const Icon(Icons.language_rounded, color: Colors.black),
            title: Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Container(
                              height: 59,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                              labelText:'Language',
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                                    value: language.language,
                                    borderRadius: BorderRadius.circular(12),
                                    isExpanded: true,
                                    onChanged: (value) {
                                            setState(() {
                                               language.setLanguage(value!);});},
                                               onSaved: (value) {
                                                 setState(() {
                                               language.setLanguage(value!);});
                                               },
                                    
                                    items: listOfLang.map((String val) {
                                            return DropdownMenuItem(
                                              value: val,
                                              child: Text(val),);}).toList(),
                   )
                            ),
                      ),
                 ),
         ),
        const ListTile(
          horizontalTitleGap: 120.0,
          leading: Icon(Icons.notifications, color: Colors.black),
          title: Text('Request', style: TextStyle(color: Colors.black)),
        ),
        const Divider(
          height: 30,
          color: Colors.black,
          thickness: 2,
        ),
        const ListTile(
          horizontalTitleGap: 120.0,
          leading: Icon(Icons.settings, color: Colors.black),
          title: Text('Settings', style: TextStyle(color: Colors.black)),
        ),
        const ListTile(
          horizontalTitleGap: 120.0,
          leading: Icon(Icons.exit_to_app, color: Colors.black),
          title: Text('Exit', style: TextStyle(color: Colors.black)),
        ),
      ]),
    );
  }
}
