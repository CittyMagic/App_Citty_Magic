import 'package:cittyquibdo/DetailPageSitio.dart';
import 'package:cittyquibdo/VistaMunicipioMagic.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore

class VistaResultado extends StatefulWidget {
  final String query;
  const VistaResultado({Key? key, required this.query});

  @override
  State<VistaResultado> createState() => _VistaResultadoState();
}

class _VistaResultadoState extends State<VistaResultado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}


