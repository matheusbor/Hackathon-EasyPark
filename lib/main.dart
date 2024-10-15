import 'dart:io';
import 'package:easypark/parking_lot.dart';

void main() {
  var parkingLot = ParkingLot(2, 5); // 2 x 5 (10 vagas)

  while (true) {
    print("\n ------------ Parking Lot System ------------");
    print("1. Register vehicle entry");
    print("2. Register vehicle exit");
    print("3. Calculate remaining time for all vehicles");
    print("4. View available parking spots");
    print("5. Exit");
    stdout.write("Choose an option: ");
    var choice = stdin.readLineSync();

    if (choice == "1") {
      stdout.write("Enter the vehicle's plate: ");
      var plate = stdin.readLineSync()!;
      stdout.write("Enter the vehicle's type: ");
      var type = stdin.readLineSync()!;
      stdout.write("Enter the maximum stay time (minutes): ");
      var maxTime = int.parse(stdin.readLineSync()!);
      stdout.write("Choose a spot (1 to 10): ");
      var spotNumber = int.parse(stdin.readLineSync()!);
      parkingLot.registerEntry(plate, type, maxTime, spotNumber);
    } else if (choice == "2") {
      stdout.write("Enter the plate of the vehicle to register the exit: ");
      var plate = stdin.readLineSync()!;
      parkingLot.registerExit(plate);
    } else if (choice == "3") {
      parkingLot.calculateRemainingTime();
    } else if (choice == "4") {
      parkingLot.viewAvailableSpots();
    } else if (choice == "5") {
      print("Shutting down system...");
      break;
    } else {
      print("Invalid option, please try again!");
    }
  }
}
