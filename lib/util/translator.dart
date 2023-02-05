import 'package:translator/translator.dart';

class Translation {
  final translator = GoogleTranslator();

  Future<String> translateArabic(String scannedText) async {
    return translator
        .translate(scannedText, from: 'auto', to: 'ar')
        .then((value) => value.text);
  }

  Future<String> translateKurdish(String scannedText) async {
    return translator
        .translate(scannedText, from: 'auto', to: 'ckb')
        .then((value) => value.text);
  }

  Future<String> translateDynamic(String scannedText, String code) async {
    return translator
        .translate(scannedText, from: 'auto', to: code)
        .then((value) => value.text);
  }
}
