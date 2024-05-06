import 'package:cittyquibdo/EjemploVistaComercio.dart';
import 'package:cittyquibdo/Google_Sign_In.dart';
import 'package:cittyquibdo/HomePage.dart';
import 'package:cittyquibdo/HomePrincipal.dart';
import 'package:cittyquibdo/SplashPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // Inicializar el binding de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configurar Firestore antes de iniciar la aplicación
  configurarFirestore();

  // Iniciar la aplicación
  runApp(const MyPage());
}

// Función para configurar Firestore
void configurarFirestore() {
  // Configurar los ajustes de Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Establecer el tamaño del caché a 10 MB y habilitar la persistencia offline
  firestore.settings = firestore.settings.copyWith(
    cacheSizeBytes: 10 * 1024 * 1024, // 10 MB
    persistenceEnabled: true,
  );
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: const MaterialApp(
        home: Scaffold(
          body: SplashPage(),
        ),
      ),
    );
  }
}


