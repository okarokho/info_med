// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';
part 'drugs.g.dart';

@HiveType(typeId: 0)
class Drugs extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String instruction;

  @HiveField(3)
  late String side_effect;

  @HiveField(4)
  late String image;
  Drugs({
    required this.name,
    required this.description,
    required this.instruction,
    required this.side_effect,
    required this.image,
  });
}
