import 'package:cittyquibdo/HomePrincipal.dart';
import 'package:cittyquibdo/VistaAgendaQuibdoMagic.dart';
import 'package:cittyquibdo/VistaComercioQuibdoMagic.dart';
import 'package:flutter/material.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<Widget> myList = [
      const HomePrincipal(),
      const VistaComercioQuibdo(),
      const VistaAgenda(),
    ];
    return myList[index];
  }
}
