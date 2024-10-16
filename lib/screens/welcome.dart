import 'package:easypark/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(WelcomeScreen());
}

class WelcomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Welcome(),
    );
  }

}

class Welcome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24,),
          Center(
            child: Image.asset("assets/EasyPark-menor.png"),
          ),
          SizedBox(height: 48,),

          Container(
            margin: EdgeInsets.only(left: 24, right: 24),
            alignment: Alignment.topLeft,
            child: Text("Seja Bem vindo(a)",
              style: Theme.of(context).textTheme.headlineLarge,),
          ),
          SizedBox(height: MediaQuery.of(context).size.height/2.5,),

          Container(
              margin: EdgeInsets.only(left: 24, right: 24),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          child: FilledButton(onPressed: null,

                              style: ButtonStyle(


                                backgroundColor: WidgetStateProperty.all(MyColors.blueNormal),

                              ),
                              child: Text("Criar nova conta",
                                style: TextStyle(color: Colors.white,fontSize:  Theme.of(context).textTheme.labelLarge?.fontSize),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12,),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          child: FilledButton(onPressed: null,

                              style: ButtonStyle(


                                backgroundColor: WidgetStateProperty.all(MyColors.blueNormalActive),
                                padding: WidgetStateProperty.all(EdgeInsets.zero),

                              ),
                              child: Text("Entrar em minha conta",
                                style: TextStyle(color: Colors.white, fontSize:  Theme.of(context).textTheme.labelLarge?.fontSize),//não mudou comparado ao texto comum
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )
          )


        ],
      ),
    );
  }

}