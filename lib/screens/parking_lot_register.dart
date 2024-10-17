import 'package:easypark/colors.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(ParkingLotRegisterScreen());

}

class ParkingLotRegisterScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ParkingScreen(),
    );
  }
  
}

class ParkingScreen extends StatefulWidget{
  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final nameController = TextEditingController();
  final vacancyController = TextEditingController();
  final floorController = TextEditingController();


  @override
  void dispose(){
    nameController.dispose();
    vacancyController.dispose();
    floorController.dispose();
    super.dispose();
  }
  
  Future<void> saveParkingLot() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", nameController.text);
    await prefs.setInt("vacancies", int.parse(vacancyController.text));
    await prefs.setInt("floor", int.parse(floorController.text));
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 24,),
         Center(child: Image.asset("assets/EasyPark-menor.png" )),
          SizedBox(height: 48,),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Text( "Criar estacionamento",
              style: Theme.of(context).textTheme.headlineLarge),
          ),
          SizedBox(height: 20,),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Text(
                "Para começar a oferecer seu estacionamento, registre-o no EasyPark.",
            style: Theme.of(context).textTheme.bodyLarge,),
          ),
          SizedBox(height: 24,),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite o nome",
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
            child: TextField(
              controller: vacancyController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite a quantidade de vagas",
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: TextField(
              controller: floorController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite a quantidade de andares",
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 4),
            alignment: Alignment.topRight,
            child: Row(
              children: [
                Expanded(child: SizedBox()),
                Expanded(
                  child: FilledButton(

                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(MyColors.blueNormal),
                    ),

                      onPressed: () async{
                      saveParkingLot();
                      final prefs = await SharedPreferences.getInstance();
                      
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              // Retrieve the text the that user has entered by using the
                              // TextEditingController.
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(nameController.text),
                                  Text(vacancyController.text),
                                  Text(floorController.text),
                                  Text("${prefs.getInt("minutes")}"),
                                  Text("${prefs.getString("plate")}"),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text("Avançar",style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}