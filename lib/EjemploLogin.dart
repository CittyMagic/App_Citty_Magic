import 'package:cittyquibdo/Google_Sign_In.dart';
import 'package:cittyquibdo/HomePage.dart';
import 'package:cittyquibdo/RegisterUsuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class EjemploLogin extends StatefulWidget {
  const EjemploLogin({super.key});

  @override
  State<EjemploLogin> createState() => _EjemploLoginState();
}

class _EjemploLoginState extends State<EjemploLogin> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final email = TextEditingController();
  final password = TextEditingController();
  String correo = "";
  String clave = "";

  Future<void> _handleSignInFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // El inicio de sesión fue exitoso
        Fluttertoast.showToast(
            msg: 'Inicio de sesión exitoso: ${result.accessToken!.token}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      } else {
        // El inicio de sesión falló
        Fluttertoast.showToast(
            msg: 'Error al iniciar sesión: ${result.status}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error al iniciar sesión: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          height: 800,
          width: 450,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/home5.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.black54,
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  const Center(
                    child: SizedBox(
                      width: 300,
                      height: 200,
                      child: Image(
                        image: AssetImage("assets/Logo/logohome.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  btnGoogle(),
                  btnFacebook(),
                  btnInvitado(),
                  const Divider(height: 15),
                  txtuser(),
                  const SizedBox(height: 10),
                  txtpassword(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      btnLogin(),
                      const SizedBox(width: 20),
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

  Container txtuser() {
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
          hintText: "Ingresa tu Correo",
        ),
        controller: email,
      ),
    );
  }

  Container txtpassword() {
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
          hintText: "Ingresa tu Contraseña",
        ),
        controller: password,
      ),
    );
  }

  ElevatedButton btnLogin() {
    return ElevatedButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: const Color.fromRGBO(255, 109, 0, 1),
      ),
      child: const Row(
        children: [
          Text(
            "Acceder",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontFamily: "Regular",
            ),
          ),
          SizedBox(height: 10),
          Icon(Icons.login, color: Colors.black),
        ],
      ),
      onPressed: () async {
        correo = email.text;
        clave = password.text;
        try {
          final datos = await firebaseAuth.signInWithEmailAndPassword(
              email: correo, password: clave);
          if (datos != true) {
            Fluttertoast.showToast(
                msg: "Seccion Iniciada"
                    "",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Datos no se encontraron",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
        }
      },
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
            "Registarse",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontFamily: "Regular",
            ),
          ),
          SizedBox(height: 15),
          Icon(Icons.person_add, color: Colors.black),
        ],
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterUsuario(),
          ),
        );
      },
    );
  }

  ElevatedButton btnGoogle() {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 109, 0, 1),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/Logo/social.png"),
            width: 25,
            height: 25,
          ),
          SizedBox(width: 10),
          Text(
            "Acceder con Google",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontFamily: "Regular",
            ),
          ),
        ],
      ),
      onPressed: () async {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.googleLogin(context);
      },
    );
  }

  ElevatedButton btnFacebook() {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 109, 0, 1),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/Logo/facebook.png"),
            width: 25,
            height: 25,
          ),
          SizedBox(width: 10),
          Text(
            "Acceder con Facebook",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontFamily: "Regular",
            ),
          ),
        ],
      ),
      onPressed: () {
        _handleSignInFacebook();
      },
    );
  }

  ElevatedButton btnInvitado() {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 109, 0, 1),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            color: Colors.black,
          ),
          SizedBox(width: 10),
          Text(
            "Acceder como invitado",
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
            builder: (context) => const HomePage(),
          ),
        );
      },
    );
  }
}
