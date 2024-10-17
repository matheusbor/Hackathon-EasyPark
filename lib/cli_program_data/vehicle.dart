class Vehicle {
  String plate;
  String type;
  DateTime entry;
  int maxTime; // in minutes

  Vehicle(this.plate, this.type, this.maxTime) : entry = DateTime.now();


  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      json['plate'],
      json['type'],
      json['maxTime'],
    )..entry = DateTime.parse(json['entry']);
  }


  Map<String, dynamic> toJson() {
    return {
      'plate': plate,
      'type': type,
      'entry': entry.toIso8601String(),
      'maxTime': maxTime,
    };
  }
}
