import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PickImage {
  File? image;

  Future pickiImageGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    } else {
      this.image = File(image.path);
      return this.image!;
    }
  }

  Future pickiImageCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    } else {
      this.image = File(image.path);
      return this.image!;
    }
  }
}
