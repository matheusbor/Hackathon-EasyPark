import 'dart:convert';

import 'package:easypark/cli_program_data/vehicle.dart';
import 'package:easypark/colors.dart';
import 'package:easypark/screens/available_vacancy.dart';
import 'package:easypark/screens/profile.dart';
import 'package:easypark/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o SharedPreferences seja inicializado

  runApp(MainApp());

}


void saveParkingSpots(List<List<Vehicle?>> spots) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> jsonSpots = spots.map((floor) => jsonEncode(floor)).toList();
  await prefs.setStringList('parking_spots', jsonSpots);
}

Future<List<List<Vehicle?>>> loadParkingSpots() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonSpots = prefs.getStringList('parking_spots');

  if (jsonSpots != null) {
    return jsonSpots
        .map((floor) => (jsonDecode(floor) as List)
        .map((spot) => spot != null ? Vehicle.fromJson(spot) : null).toList())
        .toList();
  }
  // Se não houver dados salvos, retorna a configuração inicial que você passou
  return [
    [
      Vehicle("BRA0S17", "car", 5), Vehicle("BRA0S13", "moto", 4),
      Vehicle("BRA0S13", "moto", 7), Vehicle("BRA0S17", "car", 3),
      Vehicle("BRA0S15", "van", 8),
    ],
    [
      Vehicle("BRA0S13", "moto", 5), Vehicle("BRA0S15", "van", 4),
      null, Vehicle("BRA0S13", "moto", 60), Vehicle("BRA0S17", "car", 60),
    ],
    [
      Vehicle("BRA0S15", "van", 3), Vehicle("BRA0S17", "car", 60),
      null, Vehicle("BRA0S13", "moto", 2), null,
    ],
    [
      null, Vehicle("BRA0S17", "car", 5), null, null,
      Vehicle("BRA0S13", "moto", 7),
    ],
    [
      Vehicle("BRA0S17", "car", 10), null, null, null, null,
    ],
  ];
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;

  static List<Widget> _pages = <Widget>[
    Placeholder(),
    Park(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Renderiza a página com base no índice
      bottomNavigationBar: EasyNavigation(
        _selectedIndex,
        onPageChanged: _onItemTapped, // Atualiza o índice ao selecionar uma página
      ),
    );
  }
}
// class ParkScreen extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: Park(),
//     );
//   }
//
// }


class Park extends StatefulWidget{

  @override
  State<Park> createState() => _ParkState();
}

class _ParkState extends State<Park> {
  late int quantidade;
  List<List<Vehicle?>> spots = [];
  bool isLoading = true;

  void _initializeQuantidade() {
    int availableSpots = 0;
    for (int i = 0; i < spots.length; i++) {
      for (int j = 0; j < spots[i].length; j++) {
        if (spots[i][j] == null) {
          availableSpots++;
        }
      }
    }
    setState(() {
      quantidade = availableSpots;
    });
  }
  @override
  void initState(){
    super.initState();

     _loadSpots(); // Carrega os dados no início

  }

  Future<void> _loadSpots() async {
    spots = await loadParkingSpots();
    setState(() {
      isLoading = false;
    }); // Atualiza o estado para renderizar a UI
  }
  void _saveSpots() {
    saveParkingSpots(spots);
  }

  double? calculateRemainingTime(int floorIndex, int spotIndex) {
    Vehicle? vehicle = spots[floorIndex][spotIndex];

    if (vehicle == null) {
      return null; // Se não houver veículo na vaga, retorna nulo
    }

    DateTime now = DateTime.now();
    Duration elapsedTime = now.difference(vehicle.entry);
    Duration remainingTime = Duration(minutes: vehicle.maxTime) - elapsedTime;

    if (remainingTime.isNegative || remainingTime == Duration.zero) {
      // Use o WidgetsBinding para garantir que a atualização do estado seja feita
      // fora do ciclo de construção
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          quantidade += 1;
          spots[floorIndex][spotIndex] = null;
          _saveSpots();//só é salvo se for menor que 0
        });

      });
      return 0.0;
    } else {
      // Retorna o tempo restante em minutos como um valor double
      return remainingTime.inMinutes + (remainingTime.inSeconds % 60) / 60.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeQuantidade();
    if (isLoading) {
      return Center(child: CircularProgressIndicator()); // Mostra enquanto carrega
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        DateTime now = DateTime.now();

        for (int floorIndex = 0; floorIndex < spots.length; floorIndex++) {
          for (int spotIndex = 0; spotIndex < spots[floorIndex].length; spotIndex++) {
            Vehicle? vehicle = spots[floorIndex][spotIndex];

            if (vehicle != null) {
              Duration elapsedTime = now.difference(vehicle.entry);
              Duration remainingTime = Duration(minutes: vehicle.maxTime) - elapsedTime;

              // Se o tempo restante é negativo ou zero, remove o veículo
              if (remainingTime.isNegative || remainingTime == Duration.zero) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    quantidade += 1;  // Atualiza a quantidade de vagas disponíveis
                    spots[floorIndex][spotIndex] = null;  // Libera a vaga
                    _saveSpots();
                  });
                });
              }
            }
          }
        }
      },
      child: Icon(Icons.refresh),
      backgroundColor: Colors.white,),
      body: Container(
        margin: EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
            SizedBox(height: 24,),
           Center(child: Image.asset("assets/EasyPark-menor.png" )),
            SizedBox(height: 36,),
            Expanded(
              child: ListView(
                children: [
                  Text("Estacionamento do Lucas",
                    style: Theme.of(context).textTheme.titleLarge,),
                  SizedBox(height: 8,),
                  Divider(height: 1,),
                  Text("Vagas disponíveis $quantidade/25",
                  style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 24,),
                  Text("Piso: ",
                    style: Theme.of(context).textTheme.titleMedium,),
                  Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(),
                      verticalInside: BorderSide(),

                    ),
                    children: [
                      TableRow(
                        children: [
                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[0][0];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[0][0] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(0, 0));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 0, vacancyIndex: 0)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[0][1];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[0][1] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(0, 1));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 0, vacancyIndex: 1)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[0][2];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[0][2] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(0, 2));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 0, vacancyIndex: 2)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[0][3];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[0][3] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(0, 3));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 0, vacancyIndex: 3)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[0][4];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[0][4] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(0, 4));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 0, vacancyIndex: 4)),
                        ],
                      ),

                    ],
                  ),
                  SizedBox(height: 32,),
                  Text("1º Andar:",
                    style: Theme.of(context).textTheme.titleMedium,),
                  Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(),
                      verticalInside: BorderSide(),

                    ),
                    children: [
                      TableRow(
                        children: [
                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[1][0];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[1][0] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(1, 0));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 1, vacancyIndex: 0)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[1][1];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[1][1] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(1, 1));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 1, vacancyIndex: 1)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[1][2];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[1][2] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(1, 2));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 1, vacancyIndex: 2)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[1][3];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[1][3] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(1, 3));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 1, vacancyIndex: 3)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[1][4];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[1][4] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(1, 4));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 1, vacancyIndex: 4)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32,),
                  Text("2º Andar:",
                    style: Theme.of(context).textTheme.titleMedium,),
                  Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(),
                      verticalInside: BorderSide(),

                    ),
                    children: [
                      TableRow(
                        children: [
                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[2][0];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[2][0] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(2, 0));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 2, vacancyIndex: 0)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[2][1];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[2][1] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(2, 1));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 2, vacancyIndex: 1)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[2][2];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[2][2] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(2, 2));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 2, vacancyIndex: 2)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[2][3];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[2][3] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(2, 3));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 2, vacancyIndex: 3)),

                          IconButton(onPressed: () async{
                            Vehicle? selectedVehicle = spots[2][4];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[2][4] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(2, 4));
                                  }
                              );
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 2, vacancyIndex: 4)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32,),
                  Text("3º Andar:",
                    style: Theme.of(context).textTheme.titleMedium,),
                  Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(),
                      verticalInside: BorderSide(),

                      // top: BorderSide(),
                      // bottom: BorderSide(),
                      // left: BorderSide(),
                      // right: BorderSide(),
                    ),
                    children: [
                      TableRow(
                        children: [
                          IconButton(onPressed: () async {
                            Vehicle? selectedVehicle = spots[3][0];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[3][0] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(3, 0),);
                                  });
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 3, vacancyIndex: 0)),

                          IconButton(onPressed: () async {
                            Vehicle? selectedVehicle = spots[3][1];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[3][1] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(3, 1),);
                                  });
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 3, vacancyIndex: 1)),

                          IconButton(onPressed: () async {
                            Vehicle? selectedVehicle = spots[3][2];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[3][2] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(3, 2),);
                                  });
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 3, vacancyIndex: 2)),

                          IconButton(onPressed: () async {
                            Vehicle? selectedVehicle = spots[3][3];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[3][3] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(3, 3),);
                                  });
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 3, vacancyIndex: 3)),

                          IconButton(onPressed: () async {
                            Vehicle? selectedVehicle = spots[3][4];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[3][4] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(3, 4),);
                                  });
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 3, vacancyIndex: 4)),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 32,),
                  Text("4º Andar:",
                    style: Theme.of(context).textTheme.titleMedium,),
                  Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(),
                      verticalInside: BorderSide(),

                      // top: BorderSide(),
                      // bottom: BorderSide(),
                      // left: BorderSide(),
                      // right: BorderSide(),
                    ),
                    children: [
                      TableRow(
                        children: [
                          IconButton(onPressed: () async {
                            Vehicle? selectedVehicle = spots[4][0];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[4][0] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(4, 0),);
                                  });
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 4, vacancyIndex: 0)),

                          IconButton(onPressed: () async {
                            Vehicle? selectedVehicle = spots[4][1];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[4][1] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(4, 1),);
                                  });
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 4, vacancyIndex: 1)),

                          IconButton(onPressed: () async {
                            Vehicle? selectedVehicle = spots[4][2];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[4][2] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(4, 2),);
                                  });
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 4, vacancyIndex: 2)),

                          IconButton(onPressed: () async {
                            Vehicle? selectedVehicle = spots[4][3];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[4][3] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(4, 3),);
                                  });
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 4, vacancyIndex: 3)),

                          IconButton(onPressed: () async {
                            Vehicle? selectedVehicle = spots[4][4];
                            if (selectedVehicle == null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VacancyScreen()),
                              );

                              if (result != null) {
                                String type = result['type'];
                                int minutes = result['minutes'];
                                setState(() {
                                  quantidade -= 1;
                                  spots[4][4] = Vehicle("", type, minutes);
                                  _saveSpots();
                                });
                              }
                            } else {
                              showModalBottomSheet(context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return EasyBottomSheet(timeLeft: calculateRemainingTime(4, 4),);
                                  });
                            }
                          }, icon: getIcon(spots: spots, floorIndex: 4, vacancyIndex: 4)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}



ImageIcon getIcon({required List<List<Vehicle?>> spots, required int floorIndex, required int vacancyIndex}){
  if(spots[floorIndex][vacancyIndex] == null){
    return ImageIcon(AssetImage("assets/Icon.png"));
  }
  switch (spots[floorIndex][vacancyIndex]!.type){
    case "car":
      return ImageIcon(AssetImage("assets/car.png"));
    case "van":
      return ImageIcon(AssetImage("assets/van.png"));
    case "moto":
      return ImageIcon(AssetImage("assets/moto.png"));
    default:
      return ImageIcon(AssetImage("assets/add.png"));;//para acusar um erro no debug
  }
}