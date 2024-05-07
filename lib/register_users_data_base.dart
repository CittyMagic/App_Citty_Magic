import 'package:cittyquibdo/ejemplo_login.dart';
import 'package:cittyquibdo/Repositorio/register_user_firebase.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterUsersDataBase extends StatefulWidget {
  final String idUser;
  const RegisterUsersDataBase(this.idUser, {super.key});

  @override
  State<RegisterUsersDataBase> createState() => _RegisterUsersDataBaseState();
}

class _RegisterUsersDataBaseState extends State<RegisterUsersDataBase> {
  RegisterUserFirebase objufb = RegisterUserFirebase();
  final _nombre = TextEditingController();
  final _apellidos = TextEditingController();
  final _departamento = TextEditingController();
  final _password = TextEditingController();
  final _correo = TextEditingController();
  final _direccion = TextEditingController();
  final _celular = TextEditingController();

  //void _registerUser(Usuario usuario) async {}

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
                image: AssetImage("assets/home4.jpg"), fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.black54,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: SizedBox(
                          width: 250,
                          height: 150,
                          child: Image(
                            image: AssetImage("assets/Logo/logohome.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Paso #2",
                        style: TextStyle(
                          fontFamily: "ExtraBold",
                          fontSize: 29,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        color: Colors.white60,
                        child: TextFormField(
                          style: const TextStyle(
                            fontFamily: "Regular",
                            fontSize: 12,
                          ),
                          controller: _nombre,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "¿Cual es tu nombre?"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Colors.white60,
                        child: TextFormField(
                          controller: _apellidos,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Ingrese tus apellidos"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Colors.white60,
                        child: TextFormField(
                          controller: _departamento,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "¿De donde Eres?"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Colors.white60,
                        child: TextFormField(
                          controller: _direccion,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Ingrese la Dirección"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Colors.white60,
                        child: TextFormField(
                          controller: _celular,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Ingrese el N° Celular"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Colors.white60,
                        child: TextFormField(
                          controller: _correo,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Ingrese el correo electronico"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Colors.white60,
                        child: TextFormField(
                          controller: _password,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Ingrese la Contraseña"),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(255, 109, 0, 1),
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
                                    fontFamily: "Regular",
                                    color: Colors.black,
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
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(255, 109, 0, 1),
                              textStyle: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            onPressed: () async {
                              //final idUser = widget.idUser;
                              /*var usuario = Usuario(
                                  idUser,
                                  _nombre.text,
                                  _apellidos.text,
                                  _departamento.text,
                                  _direccion.text,
                                  _correo.text,
                                  _password.text,
                                  _celular.text);*/
                              //_registerUser(usuario);
                              //var resultado = await objufb.crearUsuario(usuario);
                              Fluttertoast.showToast(
                                  msg: "Datos Guardados",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EjemploLogin(),
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.person_add,
                                  color: Colors.black,
                                ),
                                Text(
                                  "Registrarse",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: "Regular",
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
