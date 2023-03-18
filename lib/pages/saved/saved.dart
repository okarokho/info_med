import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:info_med/models/sql/db_data.dart';
import 'package:info_med/util/provider/provider.dart';
import 'package:info_med/widgets/scaffold/title_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../util/database/database.dart';
import '../../widgets/draggable/api_draggable_sheet.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  GlobalKey<AnimatedListState> key = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, value, child) {
      return value.listFavored.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 90.0, bottom: 90),
              child: AnimatedList(
                physics: const BouncingScrollPhysics(),
                key: key,
                shrinkWrap: true,
                initialItemCount: value.listFavored.length,
                itemBuilder: (context, index, animation) => animatedList(
                    value.listFavored, key, context, index, animation),
              ))
          // if the list is empty
          : Center(
              child: TitleText(
                  txt: AppLocalizations.of(context)!.notFound, size: 20),
            );
    });
  }

  // animated list
  Widget animatedList(List<DbData> list, GlobalKey<AnimatedListState> key,
          BuildContext context, int index, Animation<double> animation) =>
      SizeTransition(
        sizeFactor: animation,
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 24, right: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.grey[200],
              child: ListTile(
                // name of drug
                leading: Text(
                  list[index].name.toString(),
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
                      final map = {
                        "description": list[index].description,
                        "instruction": list[index].instruction,
                        "side": list[index].sideeffect,
                        'language': list[index].language
                      };
                      return ApiDraggableSheet(
                          map: map,
                          name: list[index].name.toString(),
                          imageUrl: list[index].image!,
                          type: list[index].type!);
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
                      final temp = list.elementAt(index);
                      key.currentState!.removeItem(index, (context, animation) {
                        list.removeAt(index);
                        return animatedList(
                            list, key, context, index - 1, animation);
                      });
                      // show undo button
                      Flushbar(
                        duration: const Duration(milliseconds: 2200),
                        barBlur: 5,
                        borderRadius: BorderRadius.circular(15),
                        backgroundColor: Colors.grey[350]!.withOpacity(0.5),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 2),
                        mainButton: TextButton(
                            onPressed: () {
                              remove = false;
                            },
                            child: Text(
                              AppLocalizations.of(context)!.undo,
                              style: const TextStyle(color: Colors.blue),
                            )),
                        messageText: TitleText(
                          txt:
                              AppLocalizations.of(context)!.deletedSuccessfully,
                          size: 18,
                        ),
                        borderColor: Colors.white,
                      ).show(context).then(
                        // if remove is true delete drug from database else insert drug to the list
                        (value) async {
                          if (remove) {
                            context
                                .read<DatabaseHelper>()
                                .deleteSaved(list[index].name.toString());
                            context.read<DataProvider>().getDataFavored();
                          } else {
                            list.insert(index, temp);
                            key.currentState!.insertItem(index);
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
      );
}
