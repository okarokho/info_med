
import 'package:flutter/material.dart';
import 'package:info_med/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/image.dart';
import '../util/shared_preference.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final theme = SharedPreference();
  Image? _image;
  final List<String> _listOfLang = ['کوردی','English','عربي'];

  @override
  void initState() {
    super.initState();
    _image = Img.image;
  }




  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape:  RoundedRectangleBorder(
        borderRadius: AppLocalizations.of(context)!.language != 'English' 
        ? const BorderRadius.only(
            topLeft: Radius.circular(20), 
            bottomLeft: Radius.circular(20)) 
        : const BorderRadius.only(
            topRight: Radius.circular(20), 
            bottomRight: Radius.circular(20)),
            ),
      child: Column(children: [
        // image in drawer
        SizedBox(
          height: 203,
          child: ClipRRect(
            borderRadius:  AppLocalizations.of(context)!.language != 'English' 
        ? const BorderRadius.only(
            topLeft: Radius.circular(20)) 
        : const BorderRadius.only(
            topRight: Radius.circular(20),),
            child: _image ,
          ),
        ),
       const SizedBox(height: 20,),
       // change language 
         Consumer<SharedPreference>(
          builder: (context, language, child) {
            return ListTile(
            horizontalTitleGap: 100.0,
            leading: const Icon(Icons.translate_sharp,size: 40 ,color: purple),
            title: Container(
                  height: 64,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0)),
                  child: DropdownButtonFormField(
                  decoration: InputDecoration(
                  labelText:AppLocalizations.of(context)!.lang,
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  ),
                ),
                        value: AppLocalizations.of(context)!.language,
                        borderRadius: BorderRadius.circular(12),
                        isExpanded: true,
                        onChanged: (value) {
                                setState(() {
                                   language.setLanguage(value.toString());});},
                        onSaved: (value) {
                                     setState(() {
                                   language.setLanguage(value.toString());});},
                        
                        items: _listOfLang.map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(val),);}).toList(),
                  )
                ),
             );
          }
        ),
       ]
      ),
    );
  }
}
