import 'dart:convert';
import 'dart:io';
import 'package:easypark/cli_program_data/vehicle.dart';

class ParkingLot {
  List<List<Vehicle?>> spots;
  String filePath;

  ParkingLot(int rows, int columns, this.filePath)
      : spots = List.generate(rows, (_) => List.filled(columns, null));

  void saveToFile() {
    var jsonData = spots.map((row) => row.map((vehicle) {
      if (vehicle != null) {
        return {
          'plate': vehicle.plate,
          'type': vehicle.type,
          'entry': vehicle.entry.toIso8601String(),
          'maxTime': vehicle.maxTime,
        };
      } else {
        return null;
      }
    }).toList()).toList();

    File(filePath).writeAsStringSync(jsonEncode(jsonData), flush: true);
  }

  void loadFromFile() {
    try {
      var jsonData = jsonDecode(File(filePath).readAsStringSync());
      for (var i = 0; i < spots.length; i++) {
        for (var j = 0; j < spots[i].length; j++) {
          var vehicleData = jsonData[i][j];
          if (vehicleData != null) {
            spots[i][j] = Vehicle(
              vehicleData['plate'],
              vehicleData['type'],
              vehicleData['maxTime'],
            )..entry = DateTime.parse(vehicleData['entry']);
          }
        }
      }
    } catch (e) {
      print("Erro ao carregar o arquivo JSON: $e");
    }
  }

  Map<String, int> convertToMatrixIndices(int spotNumber) {
    int rows = spots.length;
    int columns = spots[0].length;
    int totalSpots = rows * columns;

    if (spotNumber < 1 || spotNumber > totalSpots) {
      throw ArgumentError("Invalid spot number");
    }

    int index = spotNumber - 1;
    int row = index ~/ columns;
    int column = index % columns;
    return {'row': row, 'column': column};
  }

  void registerEntry(String plate, String type, int maxTime, int spotNumber) {
    calculateRemainingTime();
    var indices = convertToMatrixIndices(spotNumber);
    int row = indices['row']!;
    int column = indices['column']!;

    if (spots[row][column] == null) {
      spots[row][column] = Vehicle(plate, type, maxTime);
      print("Car $plate entered spot $spotNumber.");
      saveToFile();
    } else {
      print("Spot $spotNumber is already occupied!");
    }
    printSpotMatrix();
  }

  void registerExit(String plate) {
    for (var i = 0; i < spots.length; i++) {
      for (var j = 0; j < spots[i].length; j++) {
        if (spots[i][j] != null && spots[i][j]!.plate == plate) {
          var vehicle = spots[i][j]!;
          var timeSpent = DateTime.now().difference(vehicle.entry);

          int minutes = timeSpent.inMinutes;
          int seconds = timeSpent.inSeconds % 60;

          print("Car $plate exited. Time in the parking lot: $minutes minutes and $seconds seconds.");
          spots[i][j] = null;
          saveToFile();
          printSpotMatrix();
          return;
        }
      }
    }
    print("Car $plate not found!");
  }

  void calculateRemainingTime() {
    for (var i = 0; i < spots.length; i++) {
      for (var j = 0; j < spots[i].length; j++) {
        if (spots[i][j] != null) {
          var vehicle = spots[i][j]!;
          var elapsedTime = DateTime.now().difference(vehicle.entry);
          var remainingTime = Duration(minutes: vehicle.maxTime) - elapsedTime;

          if (remainingTime.inMinutes <= 0 && remainingTime.inSeconds <= 0) {
            print("Car ${vehicle.plate} has exceeded the maximum time limit. Removing from the parking lot.");
            spots[i][j] = null;
            saveToFile();
          } else {
            int minutes = remainingTime.inMinutes;
            int seconds = remainingTime.inSeconds % 60;
            print("Car ${vehicle.plate} has $minutes minutes and $seconds seconds remaining.");
          }
        }
      }
    }
  }

  void printSpotMatrix() {
    calculateRemainingTime();
    for (var row in spots) {
      print(row.map((spot) => spot != null ? 'X' : 'O').toList());
    }
  }

  void viewAvailableSpots() {
    calculateRemainingTime();
    print("Available Parking Spots:");
    int spotNumber = 1;
    for (var i = 0; i < spots.length; i++) {
      for (var j = 0; j < spots[i].length; j++) {
        if (spots[i][j] == null) {
          print("Spot $spotNumber: Available");
        } else {
          print("Spot $spotNumber: Occupied by ${spots[i][j]!.plate}");
        }
        spotNumber++;
      }
    }
  }
}