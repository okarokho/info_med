// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:info_med/util/image%20compression/image.dart';
import 'package:info_med/util/database/database.dart';
import 'package:info_med/widgets/scaffold/title_text.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/sql/db_data.dart';
import '../../util/provider/provider.dart';

// ignore: must_be_immutable
class ApiDraggableSheet extends StatefulWidget {
  ApiDraggableSheet(
      {super.key,
      required this.map,
      required this.name,
      required this.imageUrl,
      required this.type});

  // name of drug
  String name;
  // type of drug image
  String type;
  // a map containing information aboute drug
  Map<String, dynamic> map = {};
  // url of drug image
  String imageUrl;

  @override
  State<ApiDraggableSheet> createState() => _ApiDraggableSheetState();
}

class _ApiDraggableSheetState extends State<ApiDraggableSheet> {
  // bool to check drug saved or not
  bool _toggle = false;
  // list for all drugs in the database
  List<DbData> _names = [];

  @override
  void initState() {
    _initilize();
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
          // color
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.1])),
              child: Consumer<DatabaseHelper>(
                builder: (context, db, child) {
                  // get side effect list
                  final sideffect = widget.map['side']
                      .toString()
                      .substring(1, widget.map['side'].length - 1)
                      .split(RegExp("[,;،]"));
                  return Column(
                    children: [
                      // drug image
                      SingleChildScrollView(
                        controller: scrollController,
                        child: Stack(
                          children: [
                            // image and download functionality
                            SizedBox(
                              height: 211,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)),
                                // taping on image to download
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
                                              // using photo view to zoomin & zoomout
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
                                              // if image type is not asset of default image then you can download else you cant
                                              widget.type != 's'
                                                  ?
                                                  // menu with download option
                                                  Positioned(
                                                      right: 0,
                                                      top: 30,
                                                      child: PopupMenuButton(
                                                        onSelected:
                                                            (value) async {
                                                          if (value ==
                                                              'download') {
                                                            // save image
                                                            await GallerySaver
                                                                .saveImage(widget
                                                                    .imageUrl);
                                                            // show flushbar downloaded
                                                            Flushbar(
                                                              backgroundColor:
                                                                  Colors.black,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                              messageText:
                                                                  const Center(
                                                                      child:
                                                                          Text(
                                                                'Downloaded to Gallery!',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                            ).show(context);
                                                          }
                                                        },
                                                        itemBuilder:
                                                            (context) => [
                                                          const PopupMenuItem(
                                                            value: 'download',
                                                            child: Text(
                                                                'Download'),
                                                          ),
                                                        ],
                                                        icon: const Icon(
                                                          Icons
                                                              .more_vert_rounded,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  :
                                                  //empty box
                                                  const SizedBox.shrink(),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: getImage(
                                        widget.imageUrl, widget.type, 'x')),
                              ),
                            ),
                            // drug name over the image
                            Baseline(
                              baseline: 200,
                              baselineType: TextBaseline.ideographic,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Container(
                                  padding: const EdgeInsets.only(top: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200]!.withOpacity(0.9),
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5))),
                                  height: 23.3,
                                  width: 170,
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
                              ),
                            ),
                            // favourit & close icon
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // favourite
                                  Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.grey[200]!.withOpacity(0.9),
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (!_toggle) _toggle = !_toggle;
                                            if (_toggle && !_exist()) {
                                              var test = DbData(
                                                  name: widget.name,
                                                  description:
                                                      widget.map['description'],
                                                  instruction:
                                                      widget.map['instruction'],
                                                  sideeffect:
                                                      widget.map['side'],
                                                  image: widget.imageUrl,
                                                  type: widget.type,
                                                  language: AppLocalizations.of(
                                                          context)!
                                                      .local);
                                              db.insertSaved(test.tojson());
                                              context
                                                  .read<DataProvider>()
                                                  .getDataFavored();
                                            }
                                          });
                                        },
                                        color: Colors.black,
                                        icon: _toggle
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
                                  // close
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
                      // drug info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              TitleText(
                                txt: AppLocalizations.of(context)!.drugName,
                                size: 18,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(
                                txt: widget.name,
                                size: 16,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(
                                txt: AppLocalizations.of(context)!.description,
                                size: 18,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(
                                txt: widget.map['description'],
                                size: 14,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(
                                txt: AppLocalizations.of(context)!.instruction,
                                size: 18,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(
                                txt: widget.map['instruction'],
                                size: 14,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(
                                txt: AppLocalizations.of(context)!.sideeffect,
                                size: 18,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: sideffect.length,
                                itemBuilder: (context, index) => TitleText(
                                  txt: '- ${sideffect[index]}',
                                  size: 14,
                                ),
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

  // check and set the toogle flag
  Future _initilize() async {
    // get all the saved drug in the database
    _names = await DatabaseHelper.instance.selectSaved();
    setState(() {
      _toggle = _exist();
    });
  }

  // check whether the drug is saved or not
  bool _exist() => _names.any((e) => e.name == widget.name.toString());
}

// based on type of image return specific image widget
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
          return Img.imagep!;
        } else {
          return Img.image;
        }
      }
  }
}
