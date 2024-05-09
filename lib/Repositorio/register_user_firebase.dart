
import 'package:cittyquibdo/Modelo/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterUserFirebase {
  Future<String?> registerUsers(String email, String password) async {
    try {
      final credenciales = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credenciales.user?.uid;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }on FirebaseException catch(e){
      return e.code;
    }
  }

  Future<String>crearUsuario(Usuario usuario) async{
    try{
      await FirebaseFirestore.instance.collection("Usuarios").doc(usuario.id).set(usuario.convertir());
      return usuario.id;
    }on FirebaseException catch (e){
      return e.code;
    }
  }
}
