// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:info_med/models/image.dart';
import 'package:info_med/util/database.dart';
import 'package:info_med/widgets/my_text.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../models/db_data.dart';
import '../util/provider.dart';

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
                                              widget.type != 's' ?Positioned(
                                                right: 0,
                                                top: 30,
                                                child: PopupMenuButton(
                                                  onSelected: (value) async {
                                                    if (value == 'd') {                                                      

                                                        await GallerySaver
                                                            .saveImage(widget.imageUrl);
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
                                              ):Container(),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: getImage(
                                        widget.imageUrl, widget.type, 'x')),
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
                                            if (!toggle) toggle = !toggle;
                                            if (toggle && !exist()) {
                                              var test = DbData(
                                                  name: widget.name,
                                                  description: widget.map['description'],
                                                  instruction: widget.map['instruction'],
                                                  sideeffect: widget.map['side'],
                                                  image: widget.imageUrl,
                                                  type: widget.type,
                                                  language: widget.map['language'] == 'Kurdish' ?'Kurdish':widget.map['language'] == 'Arabic' ?'Arabic':'English');
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
                              TitleText(txt: widget.map['language'] == 'Kurdish' ?'ناوی دەرمان:':widget.map['language'] == 'Arabic' ?'اسم الطب:':'Medicine Name:',size: 18,ltr: widget.map['language'] == 'English'?true:false),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(txt: widget.name,size: 16,ltr: widget.map['language'] == 'English'?true:false),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(txt: widget.map['language'] == 'Kurdish' ?'دەربارە:':widget.map['language'] == 'Arabic' ?'وصف:':'Description:',size: 18,ltr: widget.map['language'] == 'English'?true:false),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(txt: widget.map['description'],size: 14,ltr: widget.map['language'] == 'English'?true:false),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(txt: widget.map['language'] == 'Kurdish' ?'بەکارهێنان:':widget.map['language'] == 'Arabic' ?'تعليمات:':'Instruction:',size: 18,ltr: widget.map['language'] == 'English'?true:false),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(txt: widget.map['instruction'],size: 14,ltr: widget.map['language'] == 'English'?true:false),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(txt: widget.map['language'] == 'Kurdish' ?'کاریگەرییە لاوەکیەکان:':widget.map['language'] == 'Arabic' ?'اعراض جانبية:':'Side Effect:',size: 18,ltr: widget.map['language'] == 'English'?true:false),
                              const SizedBox(
                                height: 8,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 
                                sideffect.length ,
                                itemBuilder: (context, index) => 
                                TitleText(txt: '- ${sideffect[index]}',size: 14,ltr: widget.map['language'] == 'English'?true:false),
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
          return  Img.imagep!;
        } else {
          return Img.image;
        }
      }
  }
}

// Future getImageFileFromAssets(String path) async {
//   final byteData = await rootBundle.load(path);
//   final file = await File('${(await getTemporaryDirectory()).path}/image.jpg').create(recursive: true);
//   await file.writeAsBytes(byteData.buffer
//       .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//   await channel.invokeMethod(
//       'saveImage',
//       <String, dynamic>{'path': file.path, 'albumName': null, 'toDcim': false},
//     );
// }
