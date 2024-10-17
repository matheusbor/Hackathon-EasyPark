import 'package:easypark/colors.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(VehicleRegisterScreen());

}

class VehicleRegisterScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: VehicleScreen(),
    );
  }
  
}

class VehicleScreen extends StatelessWidget{
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
            child: Text( "Registrar veículo",
              style: Theme.of(context).textTheme.headlineLarge),
          ),
          SizedBox(height: 20,),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Text(
                "Para estacionar seu veículo, registre ele em sua conta EasyPark.",
            style: Theme.of(context).textTheme.bodyLarge,),
          ),
          SizedBox(height: 24,),

          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite a placa",
              ),
            ),
          ),
          DropdownMenu(
              width: MediaQuery.of(context).size.width - 48,
              inputDecorationTheme: InputDecorationTheme(

                labelStyle: TextStyle(color: Colors.black),
                floatingLabelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Borda ao perder o foco
                ),
                outlineBorder: BorderSide(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Borda ao ganhar o foco
                ),
              ),
              label: Text("Eu tenho", style: TextStyle(color: Colors.black)),

              dropdownMenuEntries: [
                DropdownMenuEntry(value: "car", label: "Carro"),
                DropdownMenuEntry(value: "van", label: "Van"),
                DropdownMenuEntry(value: "moto", label: "Moto"),
              ]),
          SizedBox(height: 24,),

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
                      onPressed: null,
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