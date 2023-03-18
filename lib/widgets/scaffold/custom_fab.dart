// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:info_med/constants/colors.dart';
import 'package:info_med/models/api/second_api.dart';
import 'package:info_med/util/provider/provider.dart';
import 'package:info_med/util/scan%20util/image_picker.dart';
import 'package:info_med/util/scan%20util/ml_text_recognition.dart';
import 'package:info_med/util/provider/shared_preference.dart';
import 'package:info_med/widgets/draggable/api_draggable_sheet.dart';
import 'package:info_med/widgets/draggable/grid_draggable_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/hive/box.dart';
import '../../util/scan util/crop_image.dart';
import '../camera/camera_overlay.dart';

class MyFAB extends StatefulWidget {
  const MyFAB({super.key});

  @override
  State<MyFAB> createState() => _MyFABState();
}

class _MyFABState extends State<MyFAB> {
  // scan image
  Image? image;
  // image picker object
  final imagePicker = PickImage();
  // text recognition object
  final textDetector = TextDetection();
  // api object
  final api = Get();
  // image cropper object
  final cropper = Crop();
  // textField controller
  final TextEditingController controller = TextEditingController();
  // global key for controlling flushbar state
  final GlobalKey flushBarKey = GlobalKey();

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

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Material(
            elevation: 5,
            color: purple,
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 64,
              width: 64,
              child: Consumer2<SharedPreference, DataProvider>(
                builder: (context, value, data, child) => SpeedDial(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  backgroundColor: Colors.transparent,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.6,
                  spacing: 6,
                  spaceBetweenChildren: 2,
                  children: [
                    // camera search
                    SpeedDialChild(
                      child: const Icon(Icons.camera_alt_rounded),
                      label: AppLocalizations.of(context)!.camera,
                      onTap: () async {
                        textDetector.scannedText = '';
                        api.map.clear();
                        imagePicker.image = null;
                        Camera.test == null;
                        // open camera
                        await availableCameras().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Camera(cameras: value),
                            )));
                        // crop image
                        if (Camera.test != null) {
                          final dd = await cropper.cropImage(
                              File(Camera.test!.path), context);
                          // read text
                          await textDetector
                              .recongnizeTextInImage(XFile(dd!.path));
                          var name = _capitalize(textDetector.scannedText!);
                          // get the drug in local database based n current language
                          final boxInstance = Boxes.getBox().values.where(
                              (element) =>
                                  element.name == name &&
                                  element.language ==
                                      AppLocalizations.of(context)!.local);
                          // check saved database to see if the drug exist
                          final saved = data.listFavored.where((element) =>
                              element.name == name &&
                              element.language ==
                                  AppLocalizations.of(context)!.local);
                          // if in database
                          if (boxInstance.isNotEmpty) {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => MyDraggableSCrollableSheet(
                                name: name,
                              ),
                            );
                          } else if (saved.isNotEmpty) {
                            final map = {
                              "description": saved.first.description,
                              "instruction": saved.first.instruction,
                              "side": saved.first.sideeffect,
                              'language': saved.first.language
                            };
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ApiDraggableSheet(
                                  map: map,
                                  name: name,
                                  imageUrl: saved.first.image!,
                                  type: saved.first.type!),
                            );
                          } else {
                            Flushbar(
                              key: flushBarKey,
                              borderColor: Colors.white,
                              showProgressIndicator: true,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              barBlur: 5,
                              flushbarPosition: FlushbarPosition.TOP,
                              flushbarStyle: FlushbarStyle.FLOATING,
                              animationDuration:
                                  const Duration(milliseconds: 400),
                              reverseAnimationCurve: Curves.easeOut,
                              backgroundColor:
                                  Colors.grey[350]!.withOpacity(0.5),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 3),
                              messageText: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.loading,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                            ).show(context);
                            // search drug using api for 20 seconde
                            await Future.microtask(() => api.getByName(
                                    name, AppLocalizations.of(context)!.local))
                                .timeout(
                              const Duration(seconds: 20),
                              onTimeout: () => api.map.clear(),
                            );

                            (flushBarKey.currentWidget as Flushbar).dismiss();

                            if (api.map.isEmpty) {
                              Flushbar(
                                duration: const Duration(milliseconds: 2000),
                                borderWidth: 2,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                barBlur: 5,
                                flushbarPosition: FlushbarPosition.TOP,
                                backgroundColor:
                                    Colors.grey[350]!.withOpacity(0.5),
                                borderColor: Colors.white,
                                flushbarStyle: FlushbarStyle.FLOATING,
                                animationDuration:
                                    const Duration(milliseconds: 400),
                                reverseAnimationCurve: Curves.easeOut,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 62, vertical: 3),
                                messageText: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.sorryNotFound,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.6),
                                  ),
                                ),
                              ).show(context);
                            } else {
                              _scanModalBottomSheet(
                                  context,
                                  _capitalize(textDetector.scannedText!),
                                  await _saveImage(imagePicker.image!,
                                      textDetector.scannedText!),
                                  'p');
                            }
                          }
                        }
                      },
                    ),
                    // gallery search
                    SpeedDialChild(
                      child: const Icon(Icons.image_search_rounded),
                      label: AppLocalizations.of(context)!.gallery,
                      onTap: () async {
                        textDetector.scannedText = '';
                        api.map.clear();
                        imagePicker.image = null;
                        // open gallery
                        await imagePicker.pickiImageGallery();
                        // crop image
                        if (imagePicker.image != null) {
                          final dd = await cropper.cropImage(
                              imagePicker.image!, context);
                          // read text
                          await textDetector
                              .recongnizeTextInImage(XFile(dd!.path));
                          var name = _capitalize(textDetector.scannedText!);

                          // get the drug in local database based n current language
                          final boxInstance = Boxes.getBox().values.where(
                              (element) =>
                                  element.name == name &&
                                  element.language ==
                                      AppLocalizations.of(context)!.local);
                          // check saved database to see if the drug exist
                          final saved = data.listFavored.where((element) =>
                              element.name == name &&
                              element.language ==
                                  AppLocalizations.of(context)!.local);
                          // if in database
                          if (boxInstance.isNotEmpty) {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => MyDraggableSCrollableSheet(
                                name: name,
                              ),
                            );
                          } else if (saved.isNotEmpty) {
                            final map = {
                              "description": saved.first.description,
                              "instruction": saved.first.instruction,
                              "side": saved.first.sideeffect,
                              'language': saved.first.language
                            };
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ApiDraggableSheet(
                                  map: map,
                                  name: name,
                                  imageUrl: saved.first.image!,
                                  type: saved.first.type!),
                            );
                          } else {
                            Flushbar(
                              key: flushBarKey,
                              borderColor: Colors.white,
                              showProgressIndicator: true,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              barBlur: 5,
                              flushbarPosition: FlushbarPosition.TOP,
                              flushbarStyle: FlushbarStyle.FLOATING,
                              animationDuration:
                                  const Duration(milliseconds: 400),
                              reverseAnimationCurve: Curves.easeOut,
                              backgroundColor:
                                  Colors.grey[350]!.withOpacity(0.5),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 75, vertical: 3),
                              messageText: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.loading,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                            ).show(context);
                            // search drug using api for 20 seconde
                            await Future.microtask(() => api.getByName(
                                    name, AppLocalizations.of(context)!.local))
                                .timeout(
                              const Duration(seconds: 20),
                              onTimeout: () => api.map.clear(),
                            );

                            (flushBarKey.currentWidget as Flushbar).dismiss();

                            if (api.map.isEmpty) {
                              Flushbar(
                                duration: const Duration(milliseconds: 2000),
                                borderWidth: 2,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                barBlur: 5,
                                flushbarPosition: FlushbarPosition.TOP,
                                backgroundColor:
                                    Colors.grey[350]!.withOpacity(0.5),
                                borderColor: Colors.white,
                                flushbarStyle: FlushbarStyle.FLOATING,
                                animationDuration:
                                    const Duration(milliseconds: 400),
                                reverseAnimationCurve: Curves.easeOut,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 62, vertical: 3),
                                messageText: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.sorryNotFound,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.6),
                                  ),
                                ),
                              ).show(context);
                            } else {
                              _scanModalBottomSheet(
                                  context,
                                  _capitalize(textDetector.scannedText!),
                                  await _saveImage(imagePicker.image!,
                                      textDetector.scannedText!),
                                  'p');
                            }
                          }
                        }
                      },
                    ),
                    // text search
                    SpeedDialChild(
                      child: const Icon(Icons.text_fields_rounded),
                      label: AppLocalizations.of(context)!.searchText,
                      onTap: () async {
                        api.map.clear();
                        // show textField
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
                                    hintText:
                                        AppLocalizations.of(context)!.enterName,
                                    hintStyle: const TextStyle(
                                        leadingDistribution:
                                            TextLeadingDistribution.even,
                                        height: 1,
                                        color: Colors.grey,
                                        fontSize: 15),
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

                        String name = _capitalize(controller.text.trim());
                        // get the drug in local database based on current language
                        final boxInstance = Boxes.getBox().values.where(
                            (element) =>
                                element.name == name &&
                                element.language ==
                                    AppLocalizations.of(context)!.local);
                        // check saved database to see if the drug exist
                        final saved = data.listFavored.where((element) =>
                            element.name == name &&
                            element.language ==
                                AppLocalizations.of(context)!.local);
                        // if in database
                        if (boxInstance.isNotEmpty) {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => MyDraggableSCrollableSheet(
                              name: name,
                            ),
                          );
                        } else if (saved.isNotEmpty) {
                          final map = {
                            "description": saved.first.description,
                            "instruction": saved.first.instruction,
                            "side": saved.first.sideeffect,
                            'language': saved.first.language
                          };
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ApiDraggableSheet(
                                map: map,
                                name: name,
                                imageUrl: saved.first.image!,
                                type: saved.first.type!),
                          );
                        } else {
                          Flushbar(
                            key: flushBarKey,
                            borderColor: Colors.white,
                            showProgressIndicator: true,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                            barBlur: 5,
                            flushbarPosition: FlushbarPosition.TOP,
                            flushbarStyle: FlushbarStyle.FLOATING,
                            animationDuration:
                                const Duration(milliseconds: 400),
                            reverseAnimationCurve: Curves.easeOut,
                            backgroundColor: Colors.grey[350]!.withOpacity(0.5),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 3),
                            messageText: Center(
                              child: Text(
                                AppLocalizations.of(context)!.loading,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                          ).show(context);
                          // search drug using api for 20 seconde
                          await Future.microtask(() => api.getByName(
                                  name, AppLocalizations.of(context)!.local))
                              .timeout(
                            const Duration(seconds: 20),
                            onTimeout: () => api.map.clear(),
                          );

                          (flushBarKey.currentWidget as Flushbar).dismiss();

                          if (api.map.isEmpty) {
                            Flushbar(
                              duration: const Duration(milliseconds: 2000),
                              borderWidth: 2,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              barBlur: 5,
                              flushbarPosition: FlushbarPosition.TOP,
                              backgroundColor:
                                  Colors.grey[350]!.withOpacity(0.5),
                              borderColor: Colors.white,
                              flushbarStyle: FlushbarStyle.FLOATING,
                              animationDuration:
                                  const Duration(milliseconds: 400),
                              reverseAnimationCurve: Curves.easeOut,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 62, vertical: 3),
                              messageText: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.sorryNotFound,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.6),
                                ),
                              ),
                            ).show(context);
                            controller.clear();
                          } else {
                            _scanModalBottomSheet(
                                context,
                                _capitalize(controller.text),
                                'assets/images/drug_bottle.jpg',
                                's');
                            controller.clear();
                          }
                        }
                      },
                    ),
                  ],
                  // scan image on button
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
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

  // show data return from link
  Future<dynamic> _scanModalBottomSheet(
      BuildContext context, String name, String image, String type) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => ApiDraggableSheet(
            map: api.map, name: name, imageUrl: image, type: type));
  }

  // capitalize first letter
  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  // save drug image
  Future<String> _saveImage(File image, String imagename) async {
    String appPath = (await getApplicationDocumentsDirectory()).path;
    File file = await image.copy('$appPath/$imagename.jpg');
    return file.path;
  }
}
