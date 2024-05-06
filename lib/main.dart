import 'package:cittyquibdo/Google_Sign_In.dart';
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

  // Iniciar la aplicación
  runApp(const MyPage());
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  // Variable para almacenar los datos cargados de shared_preferences
  String? storedData;

  @override
  void initState() {
    super.initState();
    // Cargar datos de shared_preferences cuando se inicia la aplicación
    cargarDatosDeSharedPreferences();
  }
  // Función para cargar datos de shared_preferences
  Future<void> cargarDatosDeSharedPreferences() async {
    String data = await leerPreferencias('firebaseDataKey');
    setState(() {
      storedData = data; // Almacenar los datos en una variable
    });
  }

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

// Clase para manejar el estado del contador (caché de widgets)
class CounterProvider with ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }
}

// Función para guardar preferencias usando shared_preferences
void guardarPreferencias(String clave, String valor) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(clave, valor);
}

// Función para leer preferencias usando shared_preferences
Future<String> leerPreferencias(String clave) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(clave) ?? '';
}
