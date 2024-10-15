class Vehicle {
  String plate;
  String type;
  DateTime entry;
  int maxTime; // in minutes

  Vehicle(this.plate, this.type, this.maxTime) : entry = DateTime.now();
}
