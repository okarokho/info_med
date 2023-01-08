
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:info_med/services/database.dart';
import 'package:info_med/models/db_data.dart';
import 'package:info_med/services/provider.dart';
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


  Widget listItem(BuildContext context, int index, Animation<double> animation,
          List<DbData> list,databaseHelper db) =>
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
                      Map<String,dynamic> map ={"description":list[index].description,"instruction":list[index].instruction,"side":list[index].sideeffect};
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
                              listItem(context, index, animation, list,db),
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
                              child: const Text(
                                'Undo',
                                style: TextStyle(color: Colors.blue),
                              )),
                          messageText: Center(
                            child: Text(
                              'Deleted Successfuly',
                              style: TextStyle(
                                  color: Provider.of<SharedPreference>(context,
                                              listen: false)
                                          .darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
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
                    tooltip: 'Delete',
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black87,
                    )),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer2<DataProvider,databaseHelper>(
        builder: (context, value,db ,child) {
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
                        listItem(context, index, animation, value.listFavored,db),
                  ),
                ),
              )
              : const Center(
                  child:Text(
                        'No saved Drugs',
                        style: TextStyle(fontSize: 24),
                      ),
                )
        ],
      );
    });
  }
}
