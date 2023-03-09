import 'package:flutter/material.dart';
import 'package:info_med/constants/colors.dart';
import 'package:info_med/util/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class CategoryChip extends StatelessWidget {
  CategoryChip(
      {super.key,
      required this.currentIndex,
      required this.padding,
      required this.text,
      required this.temp,
      required this.selectedIndex});

  int selectedIndex;
  int currentIndex;
  double padding;
  String text;
  List<String> temp;

  @override
  Widget build(BuildContext context) {
    // createing filtered chip for categories
    return Padding(
        padding: AppLocalizations.of(context)!.language == 'English'
            ? EdgeInsets.only(left: padding)
            : EdgeInsets.only(right: padding),
        child: FilterChip(
          label: Text(text),
          checkmarkColor: purple,
          elevation: 7,
          selected: selectedIndex == currentIndex,
          backgroundColor: Colors.white,
          selectedColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onSelected: (value) =>
              Provider.of<DataProvider>(context, listen: false)
                  .updateChip(currentIndex, temp),
        ));
  }
}
