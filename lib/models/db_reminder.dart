
class DbReminder {
  String? name;
  String? type;
  int? dose;
  String? image;
  String? when;
  
  String? date;
  DateTime? time;
  DbReminder(
      {required this.name,
      required this.type,
      required this.dose,
      required this.when,
      required this.image,
      required this.date,
      required this.time});

  factory DbReminder.fromjson(Map<String, dynamic> json) {
    return DbReminder(
        name: json['name'],
        type: json['type'],
        dose: json['dose'],
        when: json['whent'],
        image: json['image'],
        date: json['date'],
        time: DateTime.parse(json['time']));
  }

  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'dose': dose,
      'whent': when,
      'date': date,
      'time':time!.toIso8601String(),
      'image': image,
      'type': type,
    };
  }
}
