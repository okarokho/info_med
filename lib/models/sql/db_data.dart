class DbData {
  String? name;
  String? description;
  String? instruction;
  String? sideeffect;
  String? image;
  String? type;
  String? language;
  DbData(
      {required this.name,
      required this.description,
      required this.instruction,
      required this.sideeffect,
      required this.image,
      required this.type});

  factory DbData.fromjson(Map<String, dynamic> json) {
    return DbData(
        name: json['name'],
        description: json['description'],
        instruction: json['instruction'],
        sideeffect: json['sideeffect'],
        image: json['image'],
        type: json['type']);
  }

  Map<String, dynamic> tojson() {
    return {
      'description': description,
      'instruction': instruction,
      'sideeffect': sideeffect,
      'name': name,
      'image': image,
      'type': type,
    };
  }
}
