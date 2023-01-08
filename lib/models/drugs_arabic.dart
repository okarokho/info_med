import 'package:hive/hive.dart';
part 'drugs_arabic.g.dart';

@HiveType(typeId: 1)
class Drugs_Arabic extends HiveObject {
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
  Drugs_Arabic({
    required this.name,
    required this.description,
    required this.instruction,
    required this.side_effect,
    required this.image,
  });
}