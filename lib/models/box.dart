import 'package:hive/hive.dart';
import 'package:info_med/models/drugs.dart';

class Boxes {
  static Box<Drugs> getBoxKurdish() => Hive.box<Drugs>('drugs');
  static Box<Drugs> getBoxEnglish() => Hive.box<Drugs>('drugs');
  static Box<Drugs> getBoxArabic() => Hive.box<Drugs>('drugs');
}
