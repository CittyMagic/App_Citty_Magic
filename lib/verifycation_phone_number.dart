import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class VerifycationPhoneNumber extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const VerifycationPhoneNumber(
      {super.key, required this.phoneNumber, required this.verificationId});

  @override
  State<VerifycationPhoneNumber> createState() =>
      _VerifycationPhoneNumberState();
}

class _VerifycationPhoneNumberState extends State<VerifycationPhoneNumber> {
  int start = 30;
  late Timer _timer;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String smsCode = "";

  void restartTimer() {
    setState(() {
      start = 30;
    });
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    var onsec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      onsec,
      (timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }

  Future<void> submitVerificationCode() async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      await firebaseAuth.signInWithCredential(phoneAuthCredential);
    } catch (e) {
      if (kDebugMode) {
        print('Error al iniciar sesión: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
                color: Colors.black,
              );
            },
          ),
        ),
        body: Column(
          children: [
            const Center(
              child: Text(
                "Ingrese el Código de verificación",
                style: TextStyle(fontSize: 22, fontFamily: "Medium"),
              ),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
                "Te enviamos el código de verificación",
                style: TextStyle(
                  fontFamily: "Regular",
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 75),
            OTPTextField(
              length: 4,
              width: MediaQuery.of(context).size.width - 50,
              fieldWidth: 58,
              otpFieldStyle: OtpFieldStyle(
                backgroundColor: Colors.black26,
                borderColor: Colors.white,
              ),
              style: const TextStyle(fontSize: 17, fontFamily: "Bold"),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onChanged: (String value) {
                smsCode = value;
              },
            ),
            const SizedBox(height: 15),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Te enviaremos el código en ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: "00:$start ",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  const TextSpan(
                    text: "segundos",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                restartTimer();
              },
              child: const Text(
                "Reenviar código",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Regular",
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 250),
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 109, 0, 1),
                ),
                onPressed: () {
                  submitVerificationCode;
                },
                child: const Text(
                  "Verificación de Código",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Medium",
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
