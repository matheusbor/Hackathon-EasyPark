import 'package:easypark/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EasyNavigation extends StatefulWidget{
  int pageIndex;
  EasyNavigation(pageIndex, {super.key}):
        pageIndex = pageIndex;
  @override
  State<EasyNavigation> createState() => _EasyNavigationState();
}

class _EasyNavigationState extends State<EasyNavigation> {
  late int currentPageIndex ;

  @override
  void initState(){
    super.initState();
    currentPageIndex = widget.pageIndex;
  }
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      indicatorColor: MyColors.blueLight,
      backgroundColor: Colors.white,
      destinations: [
        NavigationDestination(icon: Icon(Icons.notifications_none_outlined), label: "Notificações"),
        NavigationDestination(icon: ImageIcon(AssetImage("assets/carpark.png")), label: "Estacionar"),
        NavigationDestination(icon: Icon(Icons.account_circle_outlined), label: "Perfil"),
      ],
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
    );
  }
}