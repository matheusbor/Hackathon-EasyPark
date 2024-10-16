import 'package:easypark/colors.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyScreen());

}

class MyScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
  
}

class LoginScreen extends StatelessWidget{
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
            child: Text( "Fazer Login",
              style: Theme.of(context).textTheme.displayMedium),
          ),
          SizedBox(height: 20,),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Text(
                "Para gerir ou usar um estacionamento, entre em sua conta EasyPark.",
            style: Theme.of(context).textTheme.bodyLarge,),
          ),
          SizedBox(height: 24,),
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
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 4),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite sua Senha",
                helperText: "Esqueçeu sua senha?",
                helperStyle: Theme.of(context).textTheme.bodySmall,
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
                      onPressed: null,
                      child: Text("Entrar",style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}