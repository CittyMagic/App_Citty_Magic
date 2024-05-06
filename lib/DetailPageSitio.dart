import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'slider.dart';


class DetailPageSitios extends StatefulWidget {
  final String idDepartamento;
  final String idMunicipio;
  final Map<String, dynamic> sitio;

  const DetailPageSitios(
      {super.key,
      required this.sitio,
      required this.idDepartamento,
      required this.idMunicipio});

  @override
  State<DetailPageSitios> createState() => _DetailPageSitiosState();
}

class _DetailPageSitiosState extends State<DetailPageSitios> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

// Linea divisora Subtítulos.
  Widget diviSub(String campo) {
    if (widget.sitio[campo] != null) {
      return const Divider(
        height: 0,
        indent: 60,
        endIndent: 60,
        color: Color.fromRGBO(129, 135, 153, 1),
        thickness: 3,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // Subtítulos de las páginas
  Widget subtitulo(String campo) {
    try {
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Text(
          widget.sitio[campo],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontFamily: "Bold",
            color: Color.fromRGBO(129, 135, 153, 1),
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  // Subtítulos izquierda negro
  Widget subIzq(String campo) {
    try {
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Text(
          widget.sitio[campo],
          textAlign: TextAlign.left, // Alinea explícitamente el texto a la izquierda
          style: const TextStyle(
            fontSize: 18,
            fontFamily: "semibold", // Suponiendo que tienes una fuente llamada "Bold"
            color: Color.fromRGBO(0, 0, 0, 1), // Color negro
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

// Párrafos de las páginas
  Widget parrafo(String campo) {
    try {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Text(
          widget.sitio[campo],
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontFamily: "Regular",
            fontSize: 15,
            color: Color.fromRGBO(129, 135, 153, 1),
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  // Espaciado entre elementos
  Widget espacio(String campo) {
    if (widget.sitio[campo] != null) {
      return const SizedBox(height: 16);
    } else {
      return const SizedBox.shrink();
    }
  }



// Carrusel de imagenes
  Future<Widget> carrusel(String campo) async {
    try {
      List<dynamic> imagenes = widget.sitio[campo];

      // Precarga de imágenes
      for (String imageUrl in imagenes) {
        await precacheImage(NetworkImage(imageUrl), context);
      }

      // Creación del widget carrusel
      return CarouselSlider(
        items: imagenes.cast<String>().map((imagenUrl) {
          return Builder(
            builder: (context) => CachedNetworkImage(
              imageUrl: imagenUrl,
              fit: BoxFit.cover,
              //placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              //errorWidget: (context, url, error) => Icon(Icons.error),
            ),
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
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                    fontSize: 35,
                    fontFamily: "ExtraBold",
                    color: Color.fromRGBO(129, 135, 153, 1),
                  ),
                ),
              ),
              parrafo("DescripcionP1"),
              espacio("DescripcionP1"),
              FutureBuilder<Widget>(
                future: carrusel("ImagenesP"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("ImagenesP"),
              espacio("SubP2"),
              subIzq("SubP2"),
              parrafo("DescripcionP2"),
              espacio("DescripcionP2"),

              const SliderWidget(folderPath: 'gs://appcittymagic.appspot.com/fotos/App Img/2.Turismo/1.Chocó/2.Tadó/Descubre y Explora/Mumbú/Sliders Img'),
      
              subIzq("SubP3"),
              parrafo("DescripcionP3"),
              espacio("DescripcionP3"),
      
              subIzq("SubP4"),
              parrafo("DescripcionP4"),
              espacio("DescripcionP4"),
      
              subIzq("SubP5"),
              parrafo("DescripcionP5"),
              espacio("DescripcionP5"),
      
              subIzq("SubP6"),
              parrafo("DescripcionP6"),
              espacio("DescripcionP6"),
      
              subIzq("SubP7"),
              parrafo("DescripcionP7"),
              espacio("DescripcionP7"),
      
              subIzq("SubP8"),
              parrafo("DescripcionP8"),
              espacio("DescripcionP8"),
      
              espacio("Subtitulo1"),
              subtitulo("Subtitulo1"),
              diviSub("Subtitulo1"),
              espacio("Subtitulo1"),
              FutureBuilder<Widget>(
                future: carrusel("Imagenes1"),
                // Pasa el nombre del campo como argumento
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("Imagenes1"),
              parrafo("Descripcion1"),
              espacio("Descripcion1"),
      
              FutureBuilder<Widget>(
                future: carrusel("Imagenes1b"),
                // Pasa el nombre del campo como argumento
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("Imagenes1b"),
      
              parrafo("Descripcion1b"),
              espacio("Descripcion1b"),
      
      
              espacio("Subtitulo2"),
              subtitulo("Subtitulo2"),
              diviSub("Subtitulo2"),
              espacio("Subtitulo2"),
              FutureBuilder<Widget>(
                future: carrusel("Imagenes2"),
      
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("Imagenes2"),
              parrafo("Descripcion2"),
              espacio("Descripcion2"),
      
      
              espacio("Subtitulo3"),
              subtitulo("Subtitulo3"),
              diviSub("Subtitulo3"),
              espacio("Subtitulo3"),
              FutureBuilder<Widget>(
                future: carrusel("Imagenes3"),
      
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("Imagenes3"),
              parrafo("Descripcion3"),
              espacio("Descripcion3"),
      
      
              espacio("Subtitulo4"),
              subtitulo("Subtitulo4"),
              diviSub("Subtitulo4"),
              espacio("Subtitulo4"),
              FutureBuilder<Widget>(
                future: carrusel("Imagenes4"),
      
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("Imagenes4"),
              parrafo("Descripcion4"),
              espacio("Descripcion4"),
      
      
              espacio("Subtitulo5"),
              subtitulo("Subtitulo5"),
              diviSub("Subtitulo5"),
              espacio("Subtitulo5"),
              FutureBuilder<Widget>(
                future: carrusel("Imagenes5"),
      
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("Imagenes5"),
              parrafo("Descripcion5"),
              espacio("Descripcion5"),
      
      
              espacio("Subtitulo6"),
              subtitulo("Subtitulo6"),
              diviSub("Subtitulo6"),
              espacio("Subtitulo6"),
              FutureBuilder<Widget>(
                future: carrusel("Imagenes6"),
      
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("Imagenes6"),
              parrafo("Descripcion6"),
              espacio("Descripcion6"),
      
      
              espacio("Subtitulo7"),
              subtitulo("Subtitulo7"),
              diviSub("Subtitulo7"),
              espacio("Subtitulo7"),
              FutureBuilder<Widget>(
                future: carrusel("Imagenes7"),
      
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("Imagenes7"),
              parrafo("Descripcion7"),
              espacio("Descripcion7"),
      
      
              espacio("Subtitulo8"),
              subtitulo("Subtitulo8"),
              diviSub("Subtitulo8"),
              espacio("Subtitulo8"),
              FutureBuilder<Widget>(
                future: carrusel("Imagenes8"),
      
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("Imagenes8"),
              parrafo("Descripcion8"),
              espacio("Descripcion8"),
      
      
              espacio("Subtitulo9"),
              subtitulo("Subtitulo9"),
              diviSub("Subtitulo9"),
              espacio("Subtitulo9"),
              FutureBuilder<Widget>(
                future: carrusel("Imagenes9"),
      
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("Imagenes9"),
              parrafo("Descripcion9"),
              espacio("Descripcion9"),
      
      
              espacio("Subtitulo10"),
              subtitulo("Subtitulo10"),
              diviSub("Subtitulo10"),
              espacio("Subtitulo10"),
              FutureBuilder<Widget>(
                future: carrusel("Imagenes10"),
      
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              espacio("Imagenes10"),
              parrafo("Descripcion10"),
              espacio("Descripcion10"),
      
      
      
              if (widget.sitio["Mapa"] != null)
                SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.sitio["Mapa"].latitude,
                          widget.sitio["Mapa"].longitude),
                      zoom: 14.0,
                    ),
                    myLocationEnabled: true,
                  ),
                ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}
