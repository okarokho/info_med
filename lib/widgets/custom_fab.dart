// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:info_med/models/second_api.dart';
import 'package:info_med/services/image_picker.dart';
import 'package:info_med/services/ml_text_recognition.dart';
import 'package:info_med/services/shared_preference.dart';
import 'package:info_med/widgets/api_draggable_sheet.dart';
import 'package:info_med/widgets/grid_draggable_sheet.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/box.dart';
import 'camera_overlay.dart';

class MyFAB extends StatefulWidget {
  const MyFAB({super.key});

  @override
  State<MyFAB> createState() => _MyFABState();
}

class _MyFABState extends State<MyFAB> {
  Image? image;
  var imagePicker = PickImage();
  var textDetector = TextDetection();
  var kurdish = Get();
  var controller = TextEditingController();
CroppedFile? dd;
  @override
  void initState() {
    super.initState();
    image = Image.asset('assets/images/scan.png');
  }

  @override
  void dispose() {
    super.dispose();
    controller;
  }

 cropImage(File x) async {
 return await ImageCropper.platform.cropImage(
        sourcePath: x.path,
        
        aspectRatioPresets: [
         
          CropAspectRatioPreset.ratio16x9,
        ],
        uiSettings:[ AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Colors.lightGreen,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: false,
          hideBottomControls: true,
        )] );
   
  }


String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(

        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(100),
                  color:  const Color( 0xff8F00FF)),
              height: 66,
              width: 66,
              child: Consumer<SharedPreference>(
                builder: (context, value, child) => SpeedDial(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  backgroundColor: Colors.transparent,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.6,
                  spacing: 6,
                  spaceBetweenChildren: 2,
                  children: [
                    SpeedDialChild(
                      child: const Icon(Icons.camera_alt_rounded),
                      label: 'Camera',
                      onTap: () async {
                        textDetector.scannedText = '';
                         kurdish.map.clear();
                        imagePicker.image = null;
                        Camera.test==null;
                        dd=null;
                        await availableCameras().then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Camera(cameras: value),
                      )));
                       
                        if (Camera.test != null) {
                        dd = await cropImage(File(Camera.test!.path));
                           
                          
                       await textDetector.recongnizeTextInImage(
                              XFile(dd!.path));
                          var name = capitalize(
                              textDetector.scannedText!);
                          Flushbar(
                            duration: const Duration(milliseconds: 600),
                            showProgressIndicator: true,
                            borderRadius: BorderRadius.circular(15),
                            barBlur: 5,
                            flushbarPosition: FlushbarPosition.TOP,
                            flushbarStyle: FlushbarStyle.FLOATING,
                            animationDuration:
                                const Duration(milliseconds: 400),
                            borderColor: Colors.white,
                            reverseAnimationCurve: Curves.easeOut,
                            backgroundColor: Colors.grey[350]!.withOpacity(0.5),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 4),
                            messageText: Center(
                              child: Text(
                                'Loading...',
                                style: TextStyle(
                                    color: Provider.of<SharedPreference>(
                                                context,
                                                listen: false)
                                            .darkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            ),
                          ).show(context);
              
                         
                           final boxInstance = value.language == 'Kurdish'?Boxes.getBoxKurdish().values.where((element) => element.name==name):value.language == 'English'?Boxes.getBoxEnglish().values.where((element) => element.name==name):Boxes.getBoxArabic().values.where((element) => element.name==name);
                          
                          if (boxInstance.isNotEmpty) {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => MyDraggableSCrollableSheet(name: name,),
                            );
                          } else {
                             await kurdish.getByName(name);
                            if (kurdish.map.isEmpty) {
                              Flushbar(
                                duration: const Duration(milliseconds: 2000),
                                borderRadius: BorderRadius.circular(15),
                                barBlur: 5,
                                backgroundColor:
                                    Colors.grey[350]!.withOpacity(0.5),
                                borderColor: Colors.white,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 2),
                                messageText: Center(
                                  child: Text(
                                    'Sorry The Drug You Searching Not Found !!',
                                    style: TextStyle(
                                        color: Provider.of<SharedPreference>(
                                                    context,
                                                    listen: false)
                                                .darkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ),
                              ).show(context);
                            } else {
                              scanModalBottomSheet(
                                  context,
                                   capitalize(
                                      textDetector.scannedText!),
                                  await saveImage(imagePicker.image!,
                                      textDetector.scannedText!),
                                  'p');
                            }
                          }
                        }
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.image_search_rounded),
                      label: 'Gallery',
                      onTap: () async {
                        textDetector.scannedText = '';
                        kurdish.map.clear();
                        imagePicker.image = null;
                        dd=null;
                        await imagePicker.pickiImageGallery();
                        if (imagePicker.image != null) {
                            dd = await cropImage(imagePicker.image!);
                          await textDetector.recongnizeTextInImage(
                              XFile(dd!.path));
                          var name =  capitalize(
                              textDetector.scannedText!);
              
                          Flushbar(
                            duration: const Duration(milliseconds: 600),
                            borderColor: Colors.white,
                            showProgressIndicator: true,
                            borderRadius: BorderRadius.circular(15),
                            barBlur: 5,
                            flushbarPosition: FlushbarPosition.TOP,
                            flushbarStyle: FlushbarStyle.FLOATING,
                            animationDuration:
                                const Duration(milliseconds: 400),
                            reverseAnimationCurve: Curves.easeOut,
                            backgroundColor: Colors.grey[350]!.withOpacity(0.5),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 4),
                            messageText: Center(
                              child: Text(
                                'Loading...',
                                style: TextStyle(
                                    color: Provider.of<SharedPreference>(
                                                context,
                                                listen: false)
                                            .darkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            ),
                          ).show(context);
                          await kurdish.getByName(name);
                          
                            final boxInstance = value.language == 'Kurdish'?Boxes.getBoxKurdish().values.where((element) => element.name==name):value.language == 'English'?Boxes.getBoxEnglish().values.where((element) => element.name==name):Boxes.getBoxArabic().values.where((element) => element.name==name);
                       
                          if (boxInstance.isNotEmpty) {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => MyDraggableSCrollableSheet(
                               
                                  name: name,
                                ),
                            );
                          } else {
                            if (kurdish.map.isEmpty) {
                              Flushbar(
                                duration: const Duration(milliseconds: 2000),
                                borderRadius: BorderRadius.circular(15),
                                barBlur: 5,
                                backgroundColor:
                                    Colors.grey[350]!.withOpacity(0.5),
                                borderColor: Colors.white,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 2),
                                messageText: Center(
                                  child: Text(
                                    'Sorry The Drug You Searching Not Found !!',
                                    style: TextStyle(
                                        color: Provider.of<SharedPreference>(
                                                    context,
                                                    listen: false)
                                                .darkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ),
                              ).show(context);
                            } else {
                              scanModalBottomSheet(
                                  context,
                                   capitalize(
                                      textDetector.scannedText!),
                                  await saveImage(imagePicker.image!,
                                      textDetector.scannedText!),
                                  'p');
                            }
                          }
                        }
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.manage_search_rounded),
                      label: 'Name',
                      onTap: () async {
                        kurdish.map.clear();
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35.0),
                              child: Container(
                                height: 46,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[600]!),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50.0)),
                                child: TextField(
                                  maxLines: 1,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey[600],
                                    ),
                                    hintText: "Search Medicine...",
                                    hintStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                    border: InputBorder.none,
                                  ),
                                  controller: controller,
                                  onSubmitted: (value) {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
              
                        await kurdish.getByName(
                           capitalize(controller.text));
                                String name = capitalize(controller.text);
                            final boxInstance = value.language == 'Kurdish'?Boxes.getBoxKurdish().values.where((element) => element.name==name):value.language == 'English'?Boxes.getBoxEnglish().values.where((element) => element.name==name):Boxes.getBoxArabic().values.where((element) => element.name==name);
                     
                   
                        if (boxInstance.isNotEmpty) {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => MyDraggableSCrollableSheet(
                               
                                name: name,
                               ),
                          );
                        } else {
                          if (kurdish.map.isEmpty) {
                            Flushbar(
                              duration: const Duration(milliseconds: 2000),
                              borderRadius: BorderRadius.circular(15),
                              barBlur: 5,
                              borderColor: Colors.white,
                              backgroundColor:
                                  Colors.grey[350]!.withOpacity(0.5),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 2),
                              messageText: Center(
                                child: Text(
                                  'Sorry The Drug You Searching Not Found !!',
                                  style: TextStyle(
                                      color: Provider.of<SharedPreference>(
                                                  context,
                                                  listen: false)
                                              .darkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                            ).show(context);
                            controller.clear();
                          } else {
                            scanModalBottomSheet(
                                context,
                                 capitalize(controller.text),
                                'assets/images/drug_bottle.jpg',
                                's');
                            controller.clear();
                          }
                        }
                      },
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: image,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<dynamic> scanModalBottomSheet(
      BuildContext context, String name, String image, String type) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => ApiDraggableSheet(
            map: kurdish.map, name: name, imageUrl: image, type: type));
  }
}

Future<String> saveImage(File image, String imagename) async {
  String appPath = (await getApplicationDocumentsDirectory()).path;
  File file = await image.copy('$appPath/$imagename.jpg');
  return file.path;
}


class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width/8, size.height/8);
    path.lineTo(size.width-size.width/8, size.height/8);
    path.lineTo(size.width-size.width/8, size.height/4);
   path.lineTo(size.width/8, size.height/4);
     
    path.close();
    return path;
  }
  @override
  bool shouldReclip(MyClipper oldClipper) => false;
}