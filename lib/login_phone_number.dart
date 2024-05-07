import 'package:cittyquibdo/verifycation_phone_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginPhoneNumber extends StatefulWidget {
  const LoginPhoneNumber({super.key});

  @override
  State<LoginPhoneNumber> createState() => _LoginPhoneNumberState();
}

class _LoginPhoneNumberState extends State<LoginPhoneNumber> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool _isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _phoneNumber = "";
  //String _selectedCountry = "";

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    try {
      if (!_isChecked) {
        return;
      }

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      }

      final phoneNumber = _phoneNumber;

      if (phoneNumber.isEmpty) {
        return;
      }

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifycationPhoneNumber(
                phoneNumber: phoneNumber,
                verificationId: '',
              ),
            ),
          );
        },
        verificationFailed: (FirebaseAuthException authException) {},
        codeSent: (String verificationID, int? resendToken) async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifycationPhoneNumber(
                phoneNumber: phoneNumber,
                verificationId: '',
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Ingesa tu Celular",
                    style: TextStyle(
                      fontFamily: "Medium",
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntlPhoneField(
                          decoration: InputDecoration(
                            hintText: '+1234567890',
                            border: OutlineInputBorder(
                              // Establecer un borde alrededor del campo
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 109, 0, 1),
                                  width:
                                      2.0), // Para ocultar el borde del campo
                              borderRadius: BorderRadius.circular(
                                  8.0), // Borde redondeado
                            ),
                            contentPadding: const EdgeInsets.all(
                                8.0), // Ajustar el relleno interno del campo
                          ),
                          onSaved: (phone) {
                            if (phone != null) {
                              //_phoneNumber = phone.completeNumber ?? "";
                              //_selectedCountry = phone.countryCode ?? "";
                            }
                          },
                          initialCountryCode: "CO",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 275),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        shape: const CircleBorder(),
                        checkColor: Colors.white,
                        activeColor: const Color.fromRGBO(
                            255, 109, 0, 1), // Configurar la forma circular
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "He leido y acepto los ",
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    'Terminos y Condiciones y Avisos de Privacidad',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromRGBO(255, 109, 0, 1),
                      ),
                      minimumSize: WidgetStateProperty.all<Size>(
                        const Size(300, 40), // Ancho y alto del botón
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _verifyPhoneNumber(_phoneNumber);
                      }
                    },
                    child: const Text(
                      "Siguiente",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Bold",
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
