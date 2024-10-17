import 'package:easypark/colors.dart';
import 'package:easypark/screens/park.dart';
import 'package:easypark/widgets.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(ProfileApp());

}
class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2;

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
      body: _pages[_selectedIndex],
      bottomNavigationBar: EasyNavigation(
        _selectedIndex,
        onPageChanged: _onItemTapped,
      ),
    );
  }
}

// class ProfileScreen extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: Profile(),
//     );
//   }
//
// }

class Profile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
    //   bottomNavigationBar: EasyNavigation(2),
      body:
      Container(
        margin: EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
            SizedBox(height: 24,),
           Center(child: Image.asset("assets/EasyPark-menor.png" )),
            SizedBox(height: 32,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text( "Lucas Ferreira",
                        style: Theme.of(context).textTheme.headlineLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.today),
                        SizedBox(width: 4,),
                        Text( "Membro desde: 06/10/2024",
                            style: Theme.of(context).textTheme.bodySmall,)

                      ],
                    )
                  ],
                ),
                Image.asset("assets/generic_avatar.png"),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/6,),
            
            Container(
              alignment: Alignment.topLeft,
              child: Text("Veículos Registrados:",

              style: Theme.of(context).textTheme.titleLarge,),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                ImageIcon(AssetImage("assets/car.png")),
                SizedBox(width: 8,),
                Text("Placa:",
                  style: Theme.of(context).textTheme.labelLarge,),
                SizedBox(width: 4,),
                Text("BRA0S17",
                  style: Theme.of(context).textTheme.labelMedium  ,),
              ],
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                ImageIcon(AssetImage("assets/van.png")),
                SizedBox(width: 8,),
                Text("Placa:",
                  style: Theme.of(context).textTheme.labelLarge,),
                SizedBox(width: 4,),
                Text("BRA0S15",
                  style: Theme.of(context).textTheme.labelMedium  ,),
              ],
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                ImageIcon(AssetImage("assets/moto.png")),
                SizedBox(width: 8,),
                Text("Placa:",
                  style: Theme.of(context).textTheme.labelLarge,),
                SizedBox(width: 4,),
                Text("BRA0S13",
                  style: Theme.of(context).textTheme.labelMedium  ,),
              ],
            ),


          ],
        ),
      ),
    );
  }
}