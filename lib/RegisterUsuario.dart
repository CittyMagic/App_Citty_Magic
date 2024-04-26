import 'package:cittyquibdo/EjemploLogin.dart';
import 'package:cittyquibdo/RegisterUsersDataBase.dart';
import 'package:cittyquibdo/Repositorio/RegisterUserFirebase.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterUsuario extends StatefulWidget {
  const RegisterUsuario({super.key});

  @override
  State<RegisterUsuario> createState() => _RegisterUsuarioState();
}

class _RegisterUsuarioState extends State<RegisterUsuario> {
  RegisterUserFirebase objetoufb = RegisterUserFirebase();

  final _password = TextEditingController();
  final _correo = TextEditingController();
  String email = "";
  String password = "";

  void registrarUsuario() async {
    email = _correo.text;
    password = _password.text;
    final datos = await objetoufb.RegisterUsers(email, password);
    if (datos == "weak-password") {
      Fluttertoast.showToast(
          msg: "Contraseña debe tener minimo 6 caracteres",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else if (datos == "email-already-in-use") {
      Fluttertoast.showToast(
          msg: "El Email ya existe",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else if (datos == "invalid-email") {
      Fluttertoast.showToast(
          msg: "El Email no es valido",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else if (datos == "network-request-failed") {
      Fluttertoast.showToast(
          msg: "Sin Conexion",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } else if (datos == "user-not-found") {
    } else {
      final String? pk = datos;
      Fluttertoast.showToast(
          msg: "Datos Registrado",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterUsersDataBase(pk!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: 800,
          width: 450,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/home4.jpg"), fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.black54,
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const SizedBox(height: 25),
                  const Center(
                    child: Image(
                      width: 300,
                      height: 300,
                      image: AssetImage("assets/Logo/logohome.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Paso #1",
                      style: TextStyle(
                        fontFamily: "ExtraBold",
                        fontSize: 29,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  txtCorreo(),
                  const SizedBox(height: 10),
                  txtPassword(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      btnBack(),
                      const SizedBox(width: 10),
                      btnRegister(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container txtCorreo() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent, width: 2),
        borderRadius: BorderRadius.circular(50),
        color: Colors.white60,
      ),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 20,
          fontFamily: "Regular",
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.email_outlined),
          hintText: "Example@gmail.com",
        ),
        controller: _correo,
      ),
    );
  }

  Container txtPassword() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent, width: 2),
        borderRadius: BorderRadius.circular(50),
        color: Colors.white60,
      ),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 20,
          fontFamily: "Regular",
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.lock),
          hintText: "Minimo 6 caracteres",
        ),
        controller: _password,
      ),
    );
  }

  ElevatedButton btnRegister() {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 109, 0, 1),
      ),
      child: const Row(
        children: [
          Text(
            "Continuar",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontFamily: "Regular",
            ),
          ),
          Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
        ],
      ),
      onPressed: () {
        registrarUsuario();
      },
    );
  }

  ElevatedButton btnBack() {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 109, 0, 1),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          Text(
            "Volver",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontFamily: "Regular",
            ),
          ),
        ],
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EjemploLogin(),
          ),
        );
      },
    );
  }
}
