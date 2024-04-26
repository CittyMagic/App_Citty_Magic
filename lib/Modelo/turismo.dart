import 'package:cloud_firestore/cloud_firestore.dart';

class Municipio {
  final String id;
  final String nombre;
  final DocumentReference reference;  // Agrega esta propiedad para DocumentReference

  Municipio({required this.id, required this.nombre, required this.reference});

  static Municipio fromMap(Map<String, dynamic> data, String id, DocumentReference reference) {
    return Municipio(
      id: id,
      nombre: data['Nombre'] as String,
      reference: reference,
    );
  }
}


class Sitio {
  final String id;
  final String nombre;
  final String clave;

  Sitio({required this.id, required this.nombre, required this.clave});

  static Sitio fromMap(Map<String, dynamic> data, String id) {
    return Sitio(
      id: id,
      nombre: data['Nombre'] as String,
      clave: data['Clave'] as String,
    );
  }
}

class Comida {
  final String id;
  final String nombre;
  final String clave;

  Comida({required this.id, required this.nombre, required this.clave});

  static Comida fromMap(Map<String, dynamic> data, String id) {
    return Comida(
      id: id,
      nombre: data['Nombre'] as String,
      clave: data['Clave'] as String,
    );
  }
}

class Entretenimiento {
  final String id;
  final String nombre;
  final String clave;

  Entretenimiento({required this.id, required this.nombre, required this.clave});

  static Entretenimiento fromMap(Map<String, dynamic> data, String id) {
    return Entretenimiento(
      id: id,
      nombre: data['Nombre'] as String,
      clave: data['Clave'] as String,
    );
  }
}

class Cultura {
  final String id;
  final String nombre;
  final String clave;

  Cultura({required this.id, required this.nombre, required this.clave});

  static Cultura fromMap(Map<String, dynamic> data, String id) {
    return Cultura(
      id: id,
      nombre: data['Nombre'] as String,
      clave: data['Clave'] as String,
    );
  }
}

class Informacion {
  final String id;
  final String nombre;
  final String clave;

  Informacion({required this.id, required this.nombre, required this.clave});

  static Informacion fromMap(Map<String, dynamic> data, String id) {
    return Informacion(
      id: id,
      nombre: data['Nombre'] as String,
      clave: data['Clave'] as String,
    );
  }
}