import 'package:easypark/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(AvailableVacancyScreen());

}

class AvailableVacancyScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: VacancyScreen(),
    );
  }
  
}

class VacancyScreen extends StatefulWidget{
  @override
  State<VacancyScreen> createState() => _VacancyScreenState();
}

class _VacancyScreenState extends State<VacancyScreen> {
  final minutesController = TextEditingController();

  @override
  void dispose(){
    minutesController.dispose();
    super.dispose();
  }
  Future<void> occupying() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("minutes", int.parse(minutesController.text));
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 24,),

          Container(
            margin: EdgeInsets.only(left: 12, right: 24),
            child: Row(
              children: [

                IconButton(
                  padding: EdgeInsets.zero,

                  onPressed: () {},
                  icon: Icon(Icons.arrow_back, size: 36, color: Colors.black,),
                ),
                Expanded( // Ocupa o espaço restante à direita do botão
                  child: Align(
                    alignment: Alignment.center, // Centraliza a imagem dentro do espaço expandido
                    child: Image.asset("assets/EasyPark-menor.png"),
                  ),
                ),

                SizedBox(width: 24,)
              ],
            ),
          ),


          SizedBox(height: 48,),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Text( "Ocupar Vaga",
              style: Theme.of(context).textTheme.headlineLarge),
          ),
          SizedBox(height: 20,),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Text(
                "Para estacionar seu veículo, preencha os campos abaixo:",
            style: Theme.of(context).textTheme.bodyLarge,),
          ),
          SizedBox(height: 24,),

          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
            child: TextField(
              controller: minutesController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite quantos minutos precisa",
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
              label: Text("Estacionarei", style: TextStyle(color: Colors.black)),

              onSelected: (placa) async{
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("plate", placa ?? "");
              },
              dropdownMenuEntries: [
                DropdownMenuEntry(value: "BRA0S17", label: "Carro BRA0S17"),
                DropdownMenuEntry(value: "BRA0S15", label: "Van BRA0S15"),
                DropdownMenuEntry(value: "BRA0S13", label: "Moto BRA0S13"),
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
                        occupying();
                      },
                      child: Text("Estacionar",style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}