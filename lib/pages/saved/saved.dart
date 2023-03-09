import 'package:flutter/material.dart';
import 'package:info_med/pages/saved/widget/animated_list.dart';
import 'package:info_med/util/provider/provider.dart';
import 'package:info_med/widgets/scaffold/title_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(// fix consumer with animated list
        builder: (context, value, child) {
      return value.listFavored.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 90.0, bottom: 90),
              child: FavouredList(
                list: value.listFavored,
              ),
            )
          // if the list is empty
          : Center(
              child: TitleText(
                  txt: AppLocalizations.of(context)!.notFound, size: 20),
            );
    });
  }
}
