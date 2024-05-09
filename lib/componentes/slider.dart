import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  final String folderPath;
  
const SliderWidget({super.key, required this.folderPath});
  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final List<String> _imagesURLs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getImagesURLs();
  }

  Future<void> _getImagesURLs() async {
    final storage = FirebaseStorage.instance;
    final reference = storage.ref(widget.folderPath);

    debugPrint('Listing items from: ${reference.fullPath}');
    await reference.list().then((snapshot) async {
      for (final ref in snapshot.items) {
        debugPrint('Processing item: ${ref.fullPath}');
        // Obtener la URL de descarga de cada elemento
        final url = await ref.getDownloadURL();
        setState(() {
          _imagesURLs.add(url);
          _isLoading = false; // Indicar que se han cargado todas las imágenes
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoading
        ? CarouselSlider(
            items: _imagesURLs.map((image) {
              return Image.network(
                image,
                fit: BoxFit.cover,
              );
            }).toList(),
            options: CarouselOptions(
              height: 300,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 400),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          )
        : _imagesURLs.isNotEmpty // Mostrar la primera imagen si hay imágenes disponibles
            ? Image.network(
                _imagesURLs.first,
                fit: BoxFit.cover,
              )
            : Container(); // Si no hay imágenes disponibles, mostrar un contenedor vacío
  }
}
