import 'package:cittyquibdo/home_principal.dart';
import 'package:cittyquibdo/vista_agenda_quibdo_magic.dart';
import 'package:cittyquibdo/vista_comercio_quibdo_magic.dart';
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
