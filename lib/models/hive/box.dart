import 'package:hive/hive.dart';
import 'drug.dart';

class Boxes {
  static Box<Drugs> getBox() => Hive.box<Drugs>('drugs');
}
