import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum ImageSize { card, principal, card2 }

class FirebaseImage extends StatelessWidget {
  final String imageUrl;
  final ImageSize size;
  @override
  // ignore: overridden_fields
  final Key? key;

  const FirebaseImage({
    required this.imageUrl,
    this.size = ImageSize.principal,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width;
    double height;

    // Define los tamaños de imagen según el tamaño especificado
    switch (size) {
      case ImageSize.card:
        width = 100;
        height = 100;
        break;
      case ImageSize.principal:
        width = 200;
        height = 200;
        break;
      case ImageSize.card2:
        width = 150;
        height = 150;
        break;
    }

    return FutureBuilder(
      future: _getImage(context, imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Manda el error a la consola
            debugPrint('Error al cargar la imagen: ${snapshot.error}');
            return Container(); // Retornar un contenedor vacío en caso de error
          } else {
            return Image.network(
              imageUrl,
              width: width,
              height: height,
              fit: BoxFit.cover,
            );
          }
        } else {
          return Container(); // Retornar un contenedor vacío mientras se carga la imagen
        }
      },
    );
  }

  Future<ImageProvider> _getImage(BuildContext context, String imageUrl) async {
    try {
      // Obtén la referencia a la imagen en Firebase Storage
      Reference ref = FirebaseStorage.instance.ref().child(imageUrl);
      // Descarga la imagen y devuelve la imagen descargada
      final String url = await ref.getDownloadURL();
      return NetworkImage(url);
    } catch (e) {
      // En caso de error, devuelve una imagen de reemplazo o una imagen en blanco
      return const AssetImage('assets/placeholder_image.jpg');
    }
  }
}
