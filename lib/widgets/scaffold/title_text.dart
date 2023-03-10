import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TitleText extends StatelessWidget {
  TitleText({
    Key? key,
    required this.txt,
    required this.size,
  }) : super(key: key);

  String txt;
  double size;
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      txt,
      style: TextStyle(
          fontSize: size,
          fontWeight: size == 18 ? FontWeight.bold : FontWeight.w500),
    );
  }
}
