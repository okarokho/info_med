import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Img {
static Image? image;
static ImageProvider? imagep;
Img(){
  _compress();
}

_compress() async {
   image = await _compressImage('assets/images/drug_bottle.jpg');
   imagep = await _compressImagep('assets/images/drug_bottle.jpg');
}

Future<Uint8List?> _testCompressAsset(String assetName) async {
    var list = await FlutterImageCompress.compressAssetImage(
      assetName,
      minHeight: 1920,
      minWidth: 1080,
      quality: 45,
    );

    // var bytes = list!.lengthInBytes;
    // final sizeKB = bytes / 1024;
    // final sizeMB = sizeKB / 1024;
    
    // print('$sizeKB KB & $sizeMB MB');

    return list;
  }
  
Future<Image> _compressImage(img) async {
  Uint8List? image = await _testCompressAsset(img);
  ImageProvider provider = MemoryImage(image!);
  return Image(
    image: provider,
    fit: BoxFit.cover,
  );
}
Future<ImageProvider> _compressImagep(img) async {
  Uint8List? image = await _testCompressAsset(img);
  return MemoryImage(image!);
}
}
