import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class TextDetection {
  String? scannedText = '';

  // recognize text in image and return the first word
  Future<String> recongnizeTextInImage(XFile image) async {
    final inputimage = InputImage.fromFilePath(image.path);
    final textdetectore = TextRecognizer();
    RecognizedText text = await textdetectore.processImage(inputimage);
    await textdetectore.close();

    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        scannedText = line.elements.elementAt(0).text;
        break;
      }
    }

    return scannedText!;
  }
}
