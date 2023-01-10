import 'package:flutter/cupertino.dart';

  
// ignore: must_be_immutable
class TitleText extends StatelessWidget {
   TitleText({
    Key? key,
    required this.txt,
    required this.size,
    this.ltr
  }) : super(key: key);

bool? ltr = false;
String txt;
double size;
  @override
  Widget build(BuildContext context) {
    return Text(
    txt,textDirection: ltr != true ?TextDirection.rtl:TextDirection.ltr,
    style: TextStyle(
        fontSize: size, fontWeight: size == 18 ?FontWeight.bold:FontWeight.w500),
                              );
  }
}