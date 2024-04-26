import 'package:flutter/material.dart';

class BNavigator extends StatefulWidget {
  final Function currentIndex;
  const BNavigator({super.key, required this.currentIndex});

  @override
  State<BNavigator> createState() => _BNavigatorState();
}

class _BNavigatorState extends State<BNavigator> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int i) {
        setState(() {
          index = i;
          widget.currentIndex(i);
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromRGBO(45, 45, 59, 1),
      selectedItemColor: const Color.fromRGBO(255, 109, 0, 1),
      unselectedItemColor: const Color.fromRGBO(129, 135, 153, 1),
      showSelectedLabels: true,
      iconSize: 25.0,
      selectedFontSize: 14.0,
      unselectedFontSize: 12.0,
      selectedLabelStyle: const TextStyle(fontFamily: "Bold"),
      items: const [
        BottomNavigationBarItem(
          icon: Image(
            image: AssetImage("assets/tierra.png"),
            width: 20,
            height: 20,
            color: Color.fromRGBO(129, 135, 153, 1),
          ),
          label: "Turismo",
        ),
        BottomNavigationBarItem(
          icon: Image(
            image: AssetImage("assets/edificio-de-oficinas.png"),
            width: 20,
            height: 20,
            color: Color.fromRGBO(129, 135, 153, 1),
          ),
          label: "Comercio",
        ),
        BottomNavigationBarItem(
          icon: Image(
            image: AssetImage("assets/calendario.png"),
            width: 20,
            height: 20,
            color: Color.fromRGBO(129, 135, 153, 1),
          ),
          label: "Agenda",
        ),
      ],
    );
  }
}
