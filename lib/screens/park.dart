import 'package:easypark/colors.dart';
import 'package:easypark/screens/profile.dart';
import 'package:easypark/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(MainApp());

}
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  int quantidade = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        children:[
                          IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/car.png"))),
                          IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/moto.png"))),
                          IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/moto.png"))),
                          IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/car.png"))),
                          IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/van.png"))),
                        ]
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
                          children:[
                            IconButton(onPressed: (){
                              showModalBottomSheet(context: context,
                                  backgroundColor: Colors.white,
                                  builder: (context){
                                  return EasyBottomSheet();
                                  });
                            }, icon: ImageIcon(AssetImage("assets/moto.png"))),
                            IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/van.png"))),
                            IconButton(onPressed: (){
                              // return AvailableVacancyScreen();
                            }, icon: Icon(Icons.add)),
                            IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/moto.png"))),
                            IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/car.png"))),
                          ]
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
                          children:[
                            IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/van.png"))),
                            IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/car.png"))),
                            IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                            IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/moto.png"))),
                            IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                          ]
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
                          children:[
                            IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                            IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/car.png"))),
                            IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                            IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                            IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/moto.png"))),
                          ]
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
                          children:[
                            IconButton(onPressed: (){}, icon: ImageIcon(AssetImage("assets/car.png"))),
                            IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                            IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                            IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                            IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                          ]
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