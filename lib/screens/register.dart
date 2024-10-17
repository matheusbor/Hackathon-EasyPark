import 'package:easypark/colors.dart';
import 'package:easypark/screens/parking_lot_register.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyScreen());

}

class MyScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: RegisterScreen(),
    );
  }

}

class RegisterScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 24,),
          Center(child: Image.asset("assets/EasyPark-menor.png" )),
          SizedBox(height: 24,),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Text( "Criar conta",
                style: Theme.of(context).textTheme.displayMedium),
          ),
          SizedBox(height: 20,),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Text(
              "Para gerir ou usar um estacionamento, crie sua conta EasyPark.",
              style: Theme.of(context).textTheme.bodyLarge,),
          ),
          SizedBox(height: 24,),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu Nome"
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu E-mail"
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite sua Senha",

              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Confirme sua Senha",
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
              label: Text("Eu sou", style: TextStyle(color: Colors.black)),

              dropdownMenuEntries: [
                DropdownMenuEntry(value: "cliente", label: "Cliente"),
                DropdownMenuEntry(value: "gestor", label: "Gestor de um estacionamento"),
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
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ParkingLotRegisterScreen()),
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