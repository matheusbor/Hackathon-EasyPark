
import 'package:easypark/screens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(SplashScreen());
}

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),

      home: Splash(),
    );
  }

}

class Splash extends StatefulWidget{
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Delay de 3 segundos antes de navegar para a próxima página
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        _createRoute(),
        //MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => WelcomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Inicia na parte inferior
        const end = Offset.zero; // Termina na posição original
        const curve = Curves.easeInOut; // Curva da animação

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/EasyPark.png"),
      ),
    );
  }
}