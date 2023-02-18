import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:info_med/util/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/db_data.dart';
import '../../../util/provider.dart';
import '../../../widgets/api_draggable_sheet.dart';
import '../../../widgets/title_text.dart';

// ignore: must_be_immutable
class FavouredList extends StatefulWidget {
  FavouredList({
    super.key,
    required this.list
  });

List<DbData> list;

  @override
  State<FavouredList> createState() => _FavouredListState();
}

class _FavouredListState extends State<FavouredList> {
  GlobalKey<AnimatedListState> key = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      physics: const BouncingScrollPhysics(),
      key: key,
      shrinkWrap: true,
      initialItemCount: widget.list.length,
    itemBuilder: (context, index, animation) => 
    Consumer<databaseHelper>(
        builder: (context, db, child) => 
        // applying animation
        SizeTransition(
            sizeFactor: animation,
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 24, right: 24),
              child:  ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    // name of drug
                    leading: Text(
                      widget.list[index].name.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    // on tap show bottom sheet
                    onTap: () => showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          final map ={
                            "description":widget.list[index].description,
                            "instruction":widget.list[index].instruction,
                            "side":widget.list[index].sideeffect,
                            'language':widget.list[index].language};
                          return ApiDraggableSheet(
                              map: map,
                              name: widget.list[index].name.toString(),
                              imageUrl: widget.list[index].image!,
                              type: widget.list[index].type!);
                        }),
                    // delete icon
                    trailing: IconButton(
                        tooltip: AppLocalizations.of(context)!.delete,
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          bool remove = true;
                          // remove drug from the list
                          setState(() {
                            key.currentState!.removeItem(
                              index,
                              (context, animation) =>
                                  FavouredList(list: widget.list)
                            );
                            // show undo button
                            Flushbar(
                              duration: const Duration(milliseconds: 2200),
                              barBlur: 5,
                              borderRadius: BorderRadius.circular(15),
                              backgroundColor: Colors.grey[350]!.withOpacity(0.5),
                              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                              mainButton: TextButton(
                                  onPressed: () {
                                    remove = false;
                                  },
                                  child:  Text(
                                    AppLocalizations.of(context)!.undo,
                                    style: const TextStyle(color: Colors.blue),
                                  )),
                              messageText: TitleText(txt: AppLocalizations.of(context)!.deletedSuccessfully,size: 18,),
                              borderColor: Colors.white,
                            ).show(context).then(
                            // if remove is true delete drug from database else insert drug to the list 
                              (value) async {
                                if (remove) {
                                  db.delete(widget.list[index].name.toString());
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
                      ),
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}