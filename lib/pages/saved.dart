
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:info_med/services/database.dart';
import 'package:info_med/models/db_data.dart';
import 'package:info_med/services/provider.dart';
import 'package:info_med/widgets/my_text.dart';
import 'package:provider/provider.dart';

import '../services/shared_preference.dart';
import '../widgets/api_draggable_sheet.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  final key = GlobalKey<AnimatedListState>();


  @override
  Widget build(BuildContext context) {
    return Consumer3<DataProvider,databaseHelper,SharedPreference>(
        builder: (context, value,db,language,child) {
      return Stack(
        children: [
          Container(
            height: double.infinity,
            color: Colors.lightGreen,
            // child: Image.asset(
            //   'assets/images/download.png',
            //   fit: BoxFit.cover,
            // ),
          ),
          value.listFavored.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.only(top: 100.0,bottom: 90),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: AnimatedList(
                    physics: const NeverScrollableScrollPhysics(),
                    key: key,
                    shrinkWrap: true,
                    initialItemCount: value.listFavored.length,
                    itemBuilder: (context, index, animation) =>
                        listItem(context, index, animation, value.listFavored,db,language),
                  ),
                ),
              )
              :  Center(
                  child:TitleText(txt: language.language == 'Kurdish' ?'هیچ دەرمانێک نەدۆزرایەوە':language.language == 'Arabic' ?'لم يتم العثور على معلومات':'No information founded',size: 20,ltr: language.language == 'English'?true:false),                )
        ],
      );
    });
  }

  Widget listItem(BuildContext context, int index, Animation<double> animation,
          List<DbData> list,databaseHelper db,SharedPreference language) =>
      SizeTransition(
        sizeFactor: animation,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 18.0, left: 24, bottom: 0, right: 24),
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  list[index].name.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                
                onTap: () => showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      Map<String,dynamic> map ={"description":list[index].description,"instruction":list[index].instruction,"side":list[index].sideeffect,'language':list[index].language};
                      return ApiDraggableSheet(
                          map: map,
                          name: list[index].name.toString(),
                          imageUrl: list[index].image!,
                          type: list[index].type!);
                    }),
                trailing: IconButton(
                    onPressed: () {
                      var remove = true;
            
                      setState(() {
                        key.currentState!.removeItem(
                          index,
                          (context, animation) =>
                              listItem(context, index, animation, list,db,language),
                        );
            
                        Flushbar(
                          duration: const Duration(milliseconds: 1800),
                          barBlur: 5,
                          borderRadius: BorderRadius.circular(15),
                          backgroundColor: Colors.grey[350]!.withOpacity(0.5),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 2),
                          mainButton: TextButton(
                              onPressed: () {
                                remove = false;
                              },
                              child:  Text(
                                language.language == 'Kurdish' ?'گەڕانەوە':language.language == 'Arabic' ?'الغاء التحميل':'Undo',
                                style: const TextStyle(color: Colors.blue),
                              )),
                          messageText: Center(
                            child:language.language == 'Kurdish' ?TitleText(txt: 'بە سەرکەووتویی سڕایەوە',size: 18,):language.language == 'Arabic' ?TitleText(txt:'حذف بنجاح',size: 18,):TitleText(txt: 'Deleted Successfully',size: 18,),
                          ),
                          borderColor: Colors.white,
                        ).show(context).then(
                          (value) async {
                            if (remove) {
                              db.delete(list[index].name.toString());
                              context.read<DataProvider>().getDataFavored();
                            } else {
                              setState(() {
                                key.currentState!.insertItem(index);
                              });
                            }
                          },
                        );
                      });
                    },
                    tooltip: language.language == 'Kurdish' ?'سڕینەوە':language.language == 'Arabic' ?'حذف':'Delete',
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black87,
                    )),
              ),
            ),
          ),
        ),
      );

}
