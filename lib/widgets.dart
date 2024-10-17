import 'package:easypark/colors.dart';
import 'package:easypark/screens/park.dart';
import 'package:easypark/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EasyNavigation extends StatefulWidget {
  final int pageIndex;
  final Function(int) onPageChanged;

  EasyNavigation(this.pageIndex, {super.key, required this.onPageChanged});

  @override
  State<EasyNavigation> createState() => _EasyNavigationState();
}

class _EasyNavigationState extends State<EasyNavigation> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      indicatorColor: MyColors.blueLight,
      backgroundColor: Colors.white,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.notifications_none_outlined),
          label: "Notificações",
        ),
        NavigationDestination(
          icon: ImageIcon(AssetImage("assets/carpark.png")),
          label: "Estacionar",
        ),
        NavigationDestination(
          icon: Icon(Icons.account_circle_outlined),
          label: "Perfil",
        ),
      ],
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
        widget.onPageChanged(index); // Notifica a página pai sobre a mudança de índice
      },
    );
  }
}

class EasyBottomSheet extends StatefulWidget{
  @override
  State<EasyBottomSheet> createState() => _EasyBottomSheetState();
}

class _EasyBottomSheetState extends State<EasyBottomSheet> {
  double timeLeft = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24),
      child: Column(
        children: [
          SizedBox(height: 48,),
          Container(
            alignment: Alignment.topLeft ,
            child: Text("Vaga Ocupada",
              style: Theme.of(context).textTheme.titleLarge,),
          ),
          SizedBox(height: 24,),
          Row(
            children: [
              Icon(Icons.schedule),
              SizedBox(width: 4,),
              Text("Tempo restante: ",
                style: Theme.of(context).textTheme.bodyMedium,),
              SizedBox(width: 4,),
              Text("$timeLeft minutos",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.groups),
              SizedBox(width: 4,),
              Text("Veículo com seguro EasyPark",
                style: Theme.of(context).textTheme.bodyMedium,),

            ],
          ),
          SizedBox(height: 100,),
          Container(
            alignment: Alignment.topLeft ,
            child: Text("Status:",
              style: Theme.of(context).textTheme.titleMedium,),
          ),
          SizedBox(height: 8,),
          Text("Esta vaga não está disponível no momento, procure outra ou tente novamente mais tarde.",
            style: Theme.of(context).textTheme.bodyMedium,),

        ],
      ),
    );
  }
}

