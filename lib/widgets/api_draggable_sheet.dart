// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:info_med/services/database.dart';
import 'package:info_med/services/shared_preference.dart';
import 'package:info_med/widgets/my_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../models/db_data.dart';
import '../services/provider.dart';

// ignore: must_be_immutable
class ApiDraggableSheet extends StatefulWidget {
  ApiDraggableSheet(
      {super.key,
      required this.map,
      required this.name,
      required this.imageUrl,
      required this.type});
  String name;
  String type;
  

  Map<String, dynamic> map = {};
  String imageUrl;
  @override
  State<ApiDraggableSheet> createState() => _ApiDraggableSheetState();
}

class _ApiDraggableSheetState extends State<ApiDraggableSheet> {
  bool toggle = false;
  List<DbData> names = [];
// ignore: non_constant_identifier_names
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
    initilize();
    super.initState();
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
              child: Consumer<databaseHelper>(
                builder: (context, db, child) {
                  final sideffect=widget.map['side'].toString().substring(1,widget.map['side'].length-1).split(RegExp("[,;،]"));
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
                                                imageProvider: getImage(
                                                    widget.imageUrl,
                                                    widget.type,
                                                    'imgp'),
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
                                                      if (widget.type == 's') {
                                                        final file =
                                                            await getImageFileFromAssets(
                                                                widget
                                                                    .imageUrl);
                                                        await GallerySaver
                                                            .saveImage(
                                                                file.path);
                                                      } else {
                                                        await GallerySaver
                                                            .saveImage(widget
                                                                .imageUrl);
                                                      }
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
                                    child: getImage(
                                        widget.imageUrl, widget.type, 'n')),
                              ),
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
                                          color: Colors.grey[200]!
                                              .withOpacity(0.9),
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
                                        onPressed: () {
                                          setState(() {
                                            if (!toggle) toggle = !toggle;
                                            if (toggle && !exist()) {
                                              var test = DbData(
                                                  name: widget.name,
                                                  description: widget.map['description'],
                                                  instruction: widget.map['instruction'],
                                                  sideeffect: widget.map['side'],
                                                  image: widget.imageUrl,
                                                  type: widget.type,
                                                  language: context.watch<SharedPreference>().language == 'Kurdish' ?'Kurdish':context.watch<SharedPreference>().language == 'Arabic' ?'Arabic':'English');
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
                              widget.map['language'] == 'Kurdish' ?TitleText(txt: 'ناوی دەرمان:',size: 18,):widget.map['language'] == 'Arabic' ?TitleText(txt:'اسم الطب:',size: 18,):TitleText(txt: 'Medicine Name:',size: 18,ltr: true),
                              const SizedBox(
                                height: 8,
                              ),
                              widget.map['language'] == 'English' ?TitleText(txt: widget.name,size: 12,ltr: true,):TitleText(txt:widget.name,size: 12,),                              
                              const SizedBox(
                                height: 10,
                              ),
                              widget.map['language'] == 'Kurdish' ?TitleText(txt: 'دەربارە:',size: 18,):widget.map['language'] == 'Arabic' ?TitleText(txt:'وصف:',size: 18,):TitleText(txt: 'Description:',size: 18,ltr: true),
                              const SizedBox(
                                height: 8,
                              ),
                              widget.map['language'] == 'English' ?TitleText(txt: widget.map['description'],size: 12,ltr: true,):TitleText(txt:widget.map['description'],size: 12,),                              
                              const SizedBox(
                                height: 10,
                              ),
                              widget.map['language'] == 'Kurdish' ?TitleText(txt: 'بەکارهێنان:',size: 18,):widget.map['language'] == 'Arabic' ?TitleText(txt:'تعليمات:',size: 18,):TitleText(txt: 'Instruction:',size: 18,ltr: true), 
                              const SizedBox(
                                height: 8,
                              ),
                              widget.map['language'] == 'English' ?TitleText(txt: widget.map['instruction'],size: 12,ltr: true,):TitleText(txt:widget.map['instruction'],size: 12,),                              
                              const SizedBox(
                                height: 10,
                              ),
                              widget.map['language'] == 'Kurdish' ?TitleText(txt: 'کاریگەری لاوەکی:',size: 18,):widget.map['language'] == 'Arabic' ?TitleText(txt:'اعراض جانبية:',size: 18,):TitleText(txt: 'Side Effect:',size: 18,ltr: true),      
                              const SizedBox(
                                height: 8,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 
                                  sideffect.length ,
                                itemBuilder: (context, index) => 
                                widget.map['language'] == 'English' ?TitleText(txt: '- ${sideffect[index]}',size: 12,ltr: true,):TitleText(txt:'- ${sideffect[index]}',size: 12,),                              
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

getImage(String url, String type, String imgprovider) {
  switch (type) {
    case 'p':
      {
        if (imgprovider == 'imgp') {
          return FileImage(
            File(url),
          );
        } else {
          return Image.file(
            File(url),
            fit: BoxFit.cover,
          );
        }
      }

    case 'n':
      {
        if (imgprovider == 'imgp') {
          return NetworkImage(url);
        } else {
          return Image.network(
            url,
            fit: BoxFit.cover,
          );
        }
      }

    default:
      {
        if (imgprovider == 'imgp') {
          return AssetImage(url);
        } else {
          return Image.asset(
            url,
            fit: BoxFit.cover,
          );
        }
      }
  }
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load(path);

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}
