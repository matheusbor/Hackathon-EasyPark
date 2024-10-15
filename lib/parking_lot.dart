import './vehicle.dart';

class ParkingLot {
  List<List<Vehicle?>> spots;

  ParkingLot(int rows, int columns)
      : spots = List.generate(rows, (_) => List.filled(columns, null));

  /// converte um numero de vaga (1 a n) para indices de linha e coluna
  Map<String, int> convertToMatrixIndices(int spotNumber) {
    int rows = spots.length;
    int columns = spots[0].length;
    int totalSpots = rows * columns;

    if (spotNumber < 1 || spotNumber > totalSpots) {
      throw ArgumentError("Invalid spot number");
    }

    int index = spotNumber - 1; // ajustar para indice 0
    int row = index ~/ columns; // linha
    int column = index % columns; // coluna
    return {'row': row, 'column': column};
  }

  void registerEntry(String plate, String type, int maxTime, int spotNumber) {
    var indices = convertToMatrixIndices(spotNumber);
    int row = indices['row']!;
    int column = indices['column']!;

    if (spots[row][column] == null) { // se disponivel
      spots[row][column] = Vehicle(plate, type, maxTime);
      print("Car $plate entered spot $spotNumber.");
      printSpotMatrix();
    } else {
      print("Spot $spotNumber is already occupied!");
    }
  }

  void registerExit(String plate) {
    for (var i = 0; i < spots.length; i++) {
      for (var j = 0; j < spots[i].length; j++) {
        if (spots[i][j] != null && spots[i][j]!.plate == plate) {
          var vehicle = spots[i][j]!;
          var timeSpent = DateTime.now().difference(vehicle.entry);

          // tempo total em minutos e segundos
          int minutes = timeSpent.inMinutes;
          int seconds = timeSpent.inSeconds % 60;

          print("Car $plate exited. Time in the parking lot: $minutes minutes and $seconds seconds.");
          spots[i][j] = null;
          printSpotMatrix();
          return;
        }
      }
    }
    print("Car $plate not found!");
  }

  void printSpotMatrix() {
    calculateRemainingTime();
    int spotNumber = 1;
    for (var row in spots) {
      print(row.map((spot) => spot != null ? 'X' : 'O').toList());
      spotNumber += row.length;
    }
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
            spots[i][j] = null; // remover veiculo
          } else {
            int minutes = remainingTime.inMinutes;
            int seconds = remainingTime.inSeconds % 60; // segundos restantes (nao completos minutos)
            print("Car ${vehicle.plate} has $minutes minutes and $seconds seconds remaining.");
          }
        }
      }
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
