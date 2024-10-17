import 'package:easypark/cli_program_data/vehicle.dart';
import 'package:easypark/colors.dart';
import 'package:easypark/screens/park.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// class AvailableVacancyScreen extends StatelessWidget{
//   // final Vehicle vehicle;
//   //
//   // const AvailableVacancyScreen({super.key, required this.vehicle});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: VacancyScreen(),
//     );
//   }
//
// }

class VacancyScreen extends StatefulWidget{
  // final Vehicle vehicle;
  //
  // VacancyScreen(this.vehicle);
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
  Future<void> occupying(BuildContext context) async {
    print("Entrou na função occupying");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("minutes", int.parse(minutesController.text));

    String type = prefs.getString("type") ?? "";
    int minutes = prefs.getInt("minutes") ?? 1000;

    print("Type: $type, Minutes: $minutes");
    Navigator.pop(context, {'type': type, 'minutes': minutes});
    print("Saiu da função occupying");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 24,),

          Container(
            margin: EdgeInsets.only(left: 12, right: 24),
            child: Row(
              children: [

                IconButton(
                  padding: EdgeInsets.zero,

                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainApp()),
                    );
                  },
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

              onSelected: (type) async{
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("type", type ?? "");
              },
              dropdownMenuEntries: [
                DropdownMenuEntry(value: "car", label: "Carro BRA0S17"),
                DropdownMenuEntry(value: "van", label: "Van BRA0S15"),
                DropdownMenuEntry(value: "moto", label: "Moto BRA0S13"),
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
                      onPressed: ()  {
                      occupying(context);
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