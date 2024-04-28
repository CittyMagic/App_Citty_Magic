import 'package:flutter/material.dart';
// Importa Firestore

class VistaResultado extends StatefulWidget {
  final String query;
  const VistaResultado({super.key, Key? key, required this.query});

  @override
  State<VistaResultado> createState() => _VistaResultadoState();
}

class _VistaResultadoState extends State<VistaResultado> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}


