// ignore_for_file: use_build_context_synchronously, must_be_immutable


import 'dart:io';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:info_med/services/database.dart';
import 'package:info_med/models/db_data.dart';
import 'package:info_med/services/shared_preference.dart';
import 'package:info_med/widgets/my_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/box.dart';
import '../services/provider.dart';

class MyDraggableSCrollableSheet extends StatefulWidget {
  MyDraggableSCrollableSheet({super.key, required this.name});
  String name;
  @override
  State<MyDraggableSCrollableSheet> createState() =>
      _MyDraggableSCrollableSheetState();
}

class _MyDraggableSCrollableSheetState
    extends State<MyDraggableSCrollableSheet> {
  bool toggle = false;
  List<DbData> names = [];
 

  Future initilize() async {
    
    names = await databaseHelper.instance.select();
    setState(() {
      toggle = exist();
    });
  }

  bool exist() {
    bool test = false;

    for (int i = 0; i < names.length; i++) {
      if (names[i].name! == widget.name.toString()) {
        test = true;
      }
    }
    return test;
  }

  @override
  void initState() {
    super.initState();
    initilize();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.38,
      minChildSize: 0.28,
      maxChildSize: 0.9,
      
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.1])),
              child: Consumer2<databaseHelper,SharedPreference>(
                builder: (context,db, value,child) {
                   final boxInstance = value.language == 'Kurdish'?Boxes.getBoxKurdish().values.where((element) => element.name==widget.name):value.language == 'English'?Boxes.getBoxEnglish().values.where((element) => element.name==widget.name):value.language == 'Arabic'?Boxes.getBoxArabic().values.where((element) => element.name==widget.name):null;
                  final sideffect=boxInstance!.first.side_effect.toString().substring(1,boxInstance.first.side_effect.length-1).split(RegExp("[,;،]"));
                 
                  return Column(
                    children: [
                      SingleChildScrollView(
                        controller: scrollController,
                        
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 211,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  child: GestureDetector(
                                    onTap: () async {
                                      return showModalBottomSheet(
                                        isScrollControlled: true,
                                        enableDrag: false,
                                        backgroundColor: Colors.black,
                                        context: context,
                                        builder: (context) {
                                          return Stack(
                                            children: [
                                              PhotoView(
                                                imageProvider: NetworkImage(
                                                  boxInstance.first.image.toString(),
                                                ),
                                                minScale: PhotoViewComputedScale
                                                    .contained,
                                                maxScale: PhotoViewComputedScale
                                                        .contained *
                                                    4,
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 30,
                                                child: PopupMenuButton(
                                                  onSelected: (value) async {
                                                    if (value == 'd') {
                                                      final tempDir =
                                                          await getTemporaryDirectory();
                                                      final path =
                                                          '${tempDir.path}/image.jpg';
                                                      await Dio().download(
                                                          boxInstance.first.image.toString(),
                                                          path);
                                                      await GallerySaver
                                                          .saveImage(path);
                                                      Flushbar(
                                                        backgroundColor:
                                                            Colors.black,
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                        messageText:
                                                            const Center(
                                                                child: Text(
                                                          'Downloaded to Gallery!',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                      ).show(context);
                                                    }
                                                  },
                                                  itemBuilder: (context) => [
                                                    const PopupMenuItem(
                                                      value: 'd',
                                                      child: Text('Download'),
                                                    ),
                                                  ],
                                                  icon: const Icon(
                                                    Icons.more_vert_rounded,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: boxInstance.first.image.toString(),
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/drug_bottle.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                      fit: BoxFit.cover,
                                      key: UniqueKey(),
                                    ),
                                  )),
                            ),
                            Baseline(
                              baseline: 200,
                              baselineType: TextBaseline.ideographic,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5),
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5))),
                                      height: 23.3,
                                      width: 170,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 2),
                                    child: Text(
                                      widget.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.grey[200]!.withOpacity(0.9),
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        color: Colors.black,
                                        icon: const Icon(Icons.close_rounded)),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.grey[200]!.withOpacity(0.9),
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            if (!toggle) toggle = !toggle;
                                            if (toggle && !exist()) {
                                              var test = DbData(
                                                  name: widget.name,
                                                  description: boxInstance.first.description.toString(),
                                                  instruction: boxInstance.first.instruction.toString(),
                                                  sideeffect: boxInstance.first.side_effect.toString(),
                                                  image:boxInstance.first.image.toString(),
                                                  type: 'n',
                                                  language: value.language == 'Kurdish' ?'Kurdish':value.language == 'Arabic' ?'Arabic':'English');
                                              db.insert(test.tojson());
                                              context.read<DataProvider>().getDataFavored();
                                            }
                                          
                                          });
                                        },
                                        color: Colors.black,
                                        icon: toggle
                                            ? const Icon(
                                                Icons.favorite_rounded,
                                                color: Colors.red,
                                                size: 33,
                                              )
                                            : const Icon(
                                                Icons.favorite_border_rounded,
                                                size: 26,
                                              )),
                                  ),
                                ],
                              ),
                            ),
                         
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: ListView(
                            controller: scrollController,
                            children: [
                                TitleText(txt: value.language == 'Kurdish' ?'ناوی دەرمان:':value.language == 'Arabic' ?'اسم الطب:':'Medicine Name:',size: 18,ltr: value.language == 'English'?true:false),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(txt: widget.name,size: 16,ltr: value.language == 'English'?true:false),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(txt: value.language == 'Kurdish' ?'دەربارە:':value.language == 'Arabic' ?'وصف:':'Description:',size: 18,ltr: value.language == 'English'?true:false),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(txt: boxInstance.first.description,size: 14,ltr: value.language == 'English'?true:false),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(txt: value.language == 'Kurdish' ?'بەکارهێنان:':value.language == 'Arabic' ?'تعليمات:':'Instruction:',size: 18,ltr: value.language == 'English'?true:false),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(txt: boxInstance.first.instruction,size: 14,ltr: value.language == 'English'?true:false),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(txt: value.language == 'Kurdish' ?'کاریگەرییە لاوەکیەکان:':value.language == 'Arabic' ?'اعراض جانبية:':'Side Effect:',size: 18,ltr: value.language == 'English'?true:false),
                              const SizedBox(
                                height: 8,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 
                                sideffect.length ,
                                itemBuilder: (context, index) => 
                                TitleText(txt: '- ${sideffect[index]}',size: 14,ltr: value.language == 'English'?true:false),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )),
        );
      },
    );
  }
}

Future<File> urlToFile(String imageUrl) async {
  var rng = Random();
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  File file = File('$tempPath${rng.nextInt(100)}.png');
  final url = Uri.parse(imageUrl);
  http.Response response = await http.get(url);
  await file.writeAsBytes(response.bodyBytes);
  return file;
}
