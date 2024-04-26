import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailPageSitios extends StatefulWidget {
  final String IdDepartamento;
  final String IdMunicipio;
  final Map<String, dynamic> sitio;

  const DetailPageSitios(
      {Key? key,
      required this.sitio,
      required this.IdDepartamento,
      required this.IdMunicipio})
      : super(key: key);

  @override
  State<DetailPageSitios> createState() => _DetailPageSitiosState();
}

class _DetailPageSitiosState extends State<DetailPageSitios> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> imagenes = widget.sitio["Imagenes"];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: const Image(
                image: AssetImage("assets/Logo/logohome.png"),
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 270,
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: widget.sitio["IdVideo"],
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.orange,
                ),
              ),
              const SizedBox(height: 30),
              const Divider(
                height: 0,
                indent: 70,
                endIndent: 70,
                color: Color.fromRGBO(129, 135, 153, 1),
                thickness: 5,
              ),
              const SizedBox(height: null),
              Center(
                child: Text(
                  widget.sitio["Nombre"],
                  style: const TextStyle(
                    fontSize: 40,
                    fontFamily: "ExtraBold",
                    color: Color.fromRGBO(129, 135, 153, 1),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  widget.sitio["Descripcion"],
                  style: const TextStyle(
                    fontFamily: "Regular",
                    fontSize: 14,
                    color: Color.fromRGBO(129, 135, 153, 1),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CarouselSlider(
                items: imagenes.map((imagenUrl) {
                  return Image.network(
                    imagenUrl,
                    fit: BoxFit.cover,
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 300, // Altura del carrusel
                  aspectRatio: 16 / 9, // Proporción de aspecto de las imágenes
                  viewportFraction:
                      1, // Fracción del ancho del carrusel que es visible
                  initialPage: 0, // Página inicial del carrusel
                  enableInfiniteScroll:
                      true, // Desplazamiento infinito del carrusel
                  autoPlay: true, // Reproducción automática del carrusel
                  autoPlayInterval: const Duration(
                      seconds:
                          3), // Intervalo de tiempo entre cada reproducción automática
                  autoPlayAnimationDuration: const Duration(
                      milliseconds:
                          800), // Duración de la animación de reproducción automática
                  autoPlayCurve: Curves
                      .fastOutSlowIn, // Curva de animación de reproducción automática
                  enlargeCenterPage: true, // Agrandar la imagen en el centro
                  scrollDirection: Axis
                      .horizontal, // Dirección de desplazamiento del carrusel
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  widget.sitio["Descripcion"],
                  style: const TextStyle(
                    fontFamily: "Regular",
                    fontSize: 14,
                    color: Color.fromRGBO(129, 135, 153, 1),
                  ),
                ),
              ),
              const SizedBox(height: 30),
             if (widget.sitio["Mapa"] != null)
              SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                   target: LatLng(
                     widget.sitio["Mapa"].latitude,
                     widget.sitio["Mapa"].longitude
                   ),
                    zoom: 14.0,
                  ),
                  myLocationEnabled: true,
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
    );
  }
}
