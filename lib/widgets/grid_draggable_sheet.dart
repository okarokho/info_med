// ignore_for_file: use_build_context_synchronously, must_be_immutable



import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:info_med/util/database.dart';
import 'package:info_med/models/db_data.dart';
import 'package:info_med/util/shared_preference.dart';
import 'package:info_med/widgets/title_text.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/box.dart';
import '../models/image.dart';
import '../util/provider.dart';

class MyDraggableSCrollableSheet extends StatefulWidget {
  MyDraggableSCrollableSheet({super.key, required this.name});
  String name;
  @override
  State<MyDraggableSCrollableSheet> createState() =>
      _MyDraggableSCrollableSheetState();
}

class _MyDraggableSCrollableSheetState extends State<MyDraggableSCrollableSheet> {
  
  // bool to check drug saved or not
  bool _toggle = false;
  // list for all drugs in the database
  List<DbData> _names = [];
  // drug image
  ImageProvider? _image;
  // false to check whether the drug image is network or default
  bool _isAsset = false;

  @override
  void initState() {
    super.initState();
    _initilize();
    _image = Img.imagep;
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
              topLeft: Radius.circular(30), 
              topRight: Radius.circular(30)),
          // color
          child: Container(
              color: Colors.white,
              child: Consumer2<databaseHelper,SharedPreference>(
                builder: (context,db, value,child) {
                  // TODO databse
                  final boxInstance = AppLocalizations.of(context)!.language == 'کوردی'?Boxes.getBoxKurdish().values.where((element) => element.name==widget.name):AppLocalizations.of(context)!.language == 'English'?Boxes.getBoxEnglish().values.where((element) => element.name==widget.name):Boxes.getBoxArabic().values.where((element) => element.name==widget.name);
                  // get side effect list
                  final sideffect=boxInstance.first.side_effect.toString().substring(1,boxInstance.first.side_effect.length-1).split(RegExp("[,;،]"));
                 
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
                                                imageProvider: _isAsset == true ?
                                                 _image:
                                                 NetworkImage(
                                                  boxInstance.first.image.toString(),),
                                                minScale: PhotoViewComputedScale.contained,
                                                maxScale: PhotoViewComputedScale.contained * 4,
                                              ),
                                              // if image type is not asset of default image then you can download else you cant
                                               _isAsset == false? 
                                               // menu with download option
                                               Positioned(
                                                right: 0,
                                                top: 30,
                                                child: PopupMenuButton(
                                                  onSelected: (value) async {
                                                      if (value == 'download') {
                                                      
                                                        await GallerySaver
                                                          .saveImage(boxInstance.first.image.toString());
                                                        Flushbar(
                                                        backgroundColor: Colors.black,
                                                        duration: const Duration(seconds: 2),
                                                        messageText: const 
                                                          Center(
                                                            child: Text(
                                                              'Downloaded to Gallery!',
                                                              style: TextStyle(
                                                                color: Colors.white),
                                                        )
                                                       ),
                                                      ).show(context);
                                                     }
                                                  },
                                                  itemBuilder: (context) => [
                                                    const PopupMenuItem(
                                                      value: 'download',
                                                      child: Text('Download'),
                                                    ),
                                                  ],
                                                  icon: const Icon(
                                                    Icons.more_vert_rounded,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ):
                                              // empty box
                                              const SizedBox(),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: boxInstance.first.image.toString(),
                                      placeholder: (context, url) => const Center(child:CircularProgressIndicator()),
                                      errorWidget: (context, url, error) {
                                          _isAsset = true;
                                        return Image(image: _image!,fit: BoxFit.cover);
                                      },
                                      fit: BoxFit.fitHeight,
                                      key: UniqueKey(),
                                    ),
                                  )),
                            ),
                            // drug name over the image
                            Baseline(
                              baseline: 200,
                              baselineType: TextBaseline.ideographic,
                              child: Padding(
                                    padding: AppLocalizations.of(context)!.language == 'English' ? const EdgeInsets.only(left: 4.0,) : const EdgeInsets.only(right: 4.0,),
                                    child: Container(
                                      padding: AppLocalizations.of(context)!.language == 'English' ? const EdgeInsets.only(left: 8.0,top: 2) : const EdgeInsets.only(right: 8.0,top: 2),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [  
                                  // favourite
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200]!.withOpacity(0.9),
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            if (!_toggle) _toggle = !_toggle;
                                            if (_toggle && !_exist()) {
                                              var test = DbData(
                                                  name: widget.name,
                                                  description: boxInstance.first.description.toString(),
                                                  instruction: boxInstance.first.instruction.toString(),
                                                  sideeffect: boxInstance.first.side_effect.toString(),
                                                  image:boxInstance.first.image.toString(),
                                                  type: _isAsset ==true ?'s':'n',
                                                  // TODO language
                                                  language: AppLocalizations.of(context)!.language == 'کوردی' ?'Kurdish':AppLocalizations.of(context)!.language == 'English' ?'Arabic':'Arabic');
                                              db.insert(test.tojson());
                                              context.read<DataProvider>().getDataFavored();
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
                                        color:Colors.grey[200]!.withOpacity(0.9),
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        color: Colors.black,
                                        icon: const Icon(Icons.close_rounded)),
                                  )
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
                                TitleText(txt: AppLocalizations.of(context)!.drugName,size: 18,),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(txt: widget.name,size: 16,),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(txt: AppLocalizations.of(context)!.description,size: 18,),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(txt: boxInstance.first.description,size: 14,),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(txt: AppLocalizations.of(context)!.instruction,size: 18,),
                              const SizedBox(
                                height: 8,
                              ),
                              TitleText(txt: boxInstance.first.instruction,size: 14,),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleText(txt: AppLocalizations.of(context)!.sideeffect,size: 18,),
                              const SizedBox(
                                height: 8,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 
                                sideffect.length ,
                                itemBuilder: (context, index) => 
                                TitleText(txt: '- ${sideffect[index]}',size: 14,),
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
 
 // check whether the drug is saved or not
 // ignore: iterable_contains_unrelated_type
 bool _exist() => _names.contains(widget.name.toString());
// check and set the toogle flag
Future _initilize() async {
    // get all the saved drug in the database
    _names = await databaseHelper.instance.select();
    setState(() {
      _toggle = _exist();
    });
  }

}
