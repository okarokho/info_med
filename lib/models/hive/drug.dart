import 'package:hive/hive.dart';

part 'drug.g.dart';

@HiveType(typeId: 0)
class Drugs extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String instruction;

  @HiveField(3)
  late String sideEffect;

  @HiveField(4)
  late String image;

  @HiveField(5)
  late String language;
  Drugs(
      {required this.name,
      required this.description,
      required this.instruction,
      required this.sideEffect,
      required this.image,
      required this.language});
}
