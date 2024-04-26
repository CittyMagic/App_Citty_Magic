import 'package:cittyquibdo/Google_Sign_In.dart';
import 'package:cittyquibdo/HomePage.dart';
import 'package:cittyquibdo/LoginPhoneNumber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage("assets/home5.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.darken),
                  ),
                ),
                height: 550,
                child: const Padding(
                  padding: EdgeInsets.all(30),
                  child: Image(
                    image: AssetImage("assets/Logo/logohome.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Comencemos!",
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(129, 135, 153, 30),
                  fontFamily: "Medium",
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 15),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 109, 0, 1),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continuar como Invitado",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Regular",
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_right,
                        color: Colors.black,
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2, // Grosor de la línea
                        color: Colors.grey, // Color de la línea
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("O"),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromRGBO(255, 255, 255, 0.3),
                        border: Border.all(width: 0.05)),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPhoneNumber(),
                          ),
                        );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.phone,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromRGBO(255, 255, 255, 0.3),
                        border: Border.all(width: 0.05)),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromRGBO(255, 255, 255, 0.3),
                        border: Border.all(width: 0.05)),
                    child: IconButton(
                      onPressed: () async {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.googleLogin(context);
                      },
                      icon: SvgPicture.asset(
                        "assets/Logo/icons8-logo-de-google.svg",
                        semanticsLabel: "Google Logo",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
    );
  }
}
