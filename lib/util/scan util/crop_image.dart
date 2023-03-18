import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Crop {
  // croping image
  Future<CroppedFile?> cropImage(File x, BuildContext context) async {
    return await ImageCropper.platform
        .cropImage(sourcePath: x.path, aspectRatioPresets: [
      CropAspectRatioPreset.ratio16x9,
    ], uiSettings: [
      AndroidUiSettings(
        toolbarTitle: AppLocalizations.of(context)!.selectName,
        toolbarColor: Colors.lightGreen,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.ratio16x9,
        lockAspectRatio: false,
        hideBottomControls: true,
      )
    ]);
  }
}
