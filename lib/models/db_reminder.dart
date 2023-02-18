
class DbReminder {
  String? name;
  String? type;
  int? dose;
  String? image;
  String? when;
  
  String? date;
  DateTime? timeFuture;
  DateTime? timePresent;
  DbReminder(
      {required this.name,
      required this.type,
      required this.dose,
      required this.when,
      required this.image,
      required this.date,
      required this.timePresent,
      required this.timeFuture});

  factory DbReminder.fromjson(Map<String, dynamic> json) {
    return DbReminder(
        name: json['name'],
        type: json['type'],
        dose: json['dose'],
        when: json['whent'],
        image: json['image'],
        date: json['date'],
        timePresent: DateTime.parse(json['timePresent']),
        timeFuture: DateTime.parse(json['timeFuture']));
  }

  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'dose': dose,
      'whent': when,
      'date': date,
      'timeFuture':timeFuture!.toIso8601String(),
      'timePresent':timePresent!.toIso8601String(),
      'image': image,
      'type': type,
    };
  }
}
