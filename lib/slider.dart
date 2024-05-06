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

  @override
  void initState() {
    super.initState();
    _getImagesURLs();
  }

  Future<void> _getImagesURLs() async {
    final storage = FirebaseStorage.instance;
    final reference = storage.ref(widget.folderPath);

    await reference.list().then((snapshot) async {
      for (final ref in snapshot.items) {
        final downloadURL = await ref.getDownloadURL();
        setState(() {
          _imagesURLs.add(downloadURL);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _imagesURLs.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : CarouselSlider(
      items: _imagesURLs.map((image) {
        return Image.network(
          image,
          fit: BoxFit.cover,
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
    );
  }
}