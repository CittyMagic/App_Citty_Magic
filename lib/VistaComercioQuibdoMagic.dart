import 'package:cittyquibdo/DetailPageComercio.dart';
import 'package:cittyquibdo/VistaCategoria.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

class VistaComercioQuibdo extends StatefulWidget {
  const VistaComercioQuibdo({super.key});

  @override
  State<VistaComercioQuibdo> createState() => _VistaComercioQuibdoState();
}

class _VistaComercioQuibdoState extends State<VistaComercioQuibdo> {
  TextEditingController _textEditingController = TextEditingController();
  String? selectedId;
  String? imageUrl;
  Position? currentPosition;
  List searchResults = [];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _getCurrentPosition(); // Obtener la posición actual del usuario
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void searchInFirebase(String query) {
    // Implementación de búsqueda
  }

  Future<void> _getCurrentPosition() async {
    // Pide permisos y obtiene la ubicación actual del usuario
    bool serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Manejar caso en el que el servicio de ubicación no está habilitado
      return;
    }

    LocationPermission permission = await geolocator.Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Manejar caso en el que el permiso está denegado
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Manejar caso en el que el permiso está denegado permanentemente
      return;
    }

    // Obtener la ubicación actual del usuario
    currentPosition = await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    setState(() {
      // Actualizar el estado con la posición actual del usuario
    });
  }

  Future<String?> _getMunicipioIdIfWithinGeoFence() async {
    // Si no hay posición actual, no se puede verificar
    if (currentPosition == null) {
      return null;
    }

    // Obtiene los documentos de la colección "Municipios"
    final docs = await FirebaseFirestore.instance.collection('Municipios').get();

    for (var doc in docs.docs) {
      final data = doc.data() as Map<String, dynamic>?;

      // Si el documento tiene datos y coordenadas de geolocalización
      if (data != null && data.containsKey('Mapa')) {
        GeoPoint municipioGeoPoint = data['Mapa'] as GeoPoint;

        // Calcula la distancia entre la posición actual del usuario y las coordenadas del municipio
        double distanceInMeters = geolocator.Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          municipioGeoPoint.latitude,
          municipioGeoPoint.longitude,
        );

        // Define el radio de geolocalización en metros (ejemplo: 1000 metros)
        double geoFenceRadius = 1000.0;

        // Si la distancia está dentro del radio de geolocalización
        if (distanceInMeters <= geoFenceRadius) {
          // Retorna el ID del municipio si está dentro del radio
          return doc.id;
        }
      }
    }

    return null; // Retorna null si no se encuentra ningún municipio dentro del radio
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getMunicipioIdIfWithinGeoFence(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se calcula la ubicación
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          // Si el usuario está dentro del radio de geolocalización del municipio
          selectedId = snapshot.data;

          if (selectedId != null) {
            // Usuario dentro del radio de geolocalización del municipio
            return _buildVistaComercio(context);
          } else {
            // Usuario fuera del radio de geolocalización, mostrar AppBar para seleccionar la ciudad
            return _buildCitySelection(context);
          }
        }
      },
    );
  }

  Widget _buildCitySelection(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecciona tu ciudad"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Municipios').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          final items = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>?;

            // Verificar que 'data' no sea nulo y sea un Map<String, dynamic>
            if (data != null) {
              final nombre = data['Nombre'] as String?;

              if (nombre != null) {
                // Crear un DropdownMenuItem
                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Text(
                    nombre,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }
            }

            return null;
          }).where((item) => item != null).cast<DropdownMenuItem<String>>().toList();

          return Center(
            child: DropdownButton<String>(
              value: selectedId,
              onChanged: (newValue) {
                setState(() {
                  selectedId = newValue;
                  // Future para que el cambio de ciudad sea confirmado
                  Navigator.pop(context, true);
                });
              },
              items: items,
              hint: const Text('Selecciona una ciudad'),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 40),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVistaComercio(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Municipios').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(); // Retorna un contenedor vacío mientras no hay datos
              }

              final docs = snapshot.data!.docs;

              // Procesar los documentos de la colección 'Municipios'
              final items = docs
                  .map((doc) {
                final data = doc.data() as Map<String, dynamic>?;

                // Verificar que 'data' no sea nulo y sea un Map<String, dynamic>
                if (data != null) {
                  // Obtener el nombre del municipio desde 'data'
                  final nombre = data['Nombre'] as String?;

                  // Verificar si el nombre no es nulo
                  if (nombre != null) {
                    // Si tienes una propiedad 'BannerUrl' en los documentos
                    final bannerUrl =
                    data['ImagenPortada'] as String?;

                    // Crear un DropdownMenuItem
                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text(
                        nombre,
                        overflow: TextOverflow.ellipsis, // Limita la longitud del texto mostrado
                      ),
                      onTap: () {
                        // Actualizar la imagen cuando se seleccione un municipio
                        if (bannerUrl != null) {
                          setState(() {
                            imageUrl =
                                bannerUrl; // Actualiza la imagen con la URL seleccionada
                          });
                        }
                      },
                    );
                  }
                }
                // Retornar null si no se pudo crear el DropdownMenuItem
                return null;
              })
                  .where((item) => item != null) // Filtrar elementos nulos
                  .cast<DropdownMenuItem<String>>() // Convertir a tipo correcto
                  .toList(); // Convertir a lista

              return DropdownButton<String>(
                value: selectedId,
                onChanged: (newValue) {
                  setState(() {
                    selectedId = newValue;
                    // Actualizar la URL de la imagen cuando cambia la selección
                    final doc = docs.firstWhere((d) => d.id == newValue);
                    final data = doc.data() as Map<String, dynamic>?;
                    if (data != null) {
                      imageUrl = data['ImagenPortada'] as String?;
                    }
                  });
                },
                items: items,
                hint: const Text('Selecciona una opción'),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 40),
              );
            },
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: const Image(
                image: AssetImage("assets/Logo/Logo_Blanco.png"),
                width: 100,
                height: 75,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 450,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageUrl != null
                        ? NetworkImage(
                        imageUrl!) // Mostrar la imagen de la URL seleccionada
                        : const AssetImage("assets/banner-citty2.jpg")
                    as ImageProvider, // Imagen predeterminada
                    fit: BoxFit.cover,
                  ),
                ),
                child: Scaffold(
                  backgroundColor: Colors.black54,
                  body: Center(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 160),
                            const Text(
                              "Descubre Quibdó",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'ExtraBold',
                              ),
                            ),
                            const Text(
                              "Descubre los mejores lugares de tu ciudad",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Regular",
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              color: Colors.transparent,
                              height: 200,
                              width: 350,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _textEditingController,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(255, 109, 0, 1),
                                      fontSize: 20,
                                      fontFamily: 'Regular',
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white70,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                      hintText: "Ej: Hamburguesa, Hotel...",
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Regular',
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 9),
                                    ),
                                    onChanged: (query) {
                                      setState(() {});
                                      searchInFirebase(query);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: _textEditingController.text.isNotEmpty,
                                    child: Expanded(
                                      child: Container(
                                        color: Colors.white70,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: searchResults.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Row(
                                                children: [
                                                  const Icon(Icons.search_sharp),
                                                  const SizedBox(width: 15),
                                                  Text(searchResults[index]["Nombre"] ?? ""),
                                                ],
                                              ),
                                              onTap: () async {
                                                String idComercio = searchResults[index]["idComercio"];
                                                String idCategoria = searchResults[index]["idCategoria"];

                                                // Obtener los detalles completos del comercio desde Firestore usando los IDs
                                                DocumentSnapshot comercioSnapshot = await FirebaseFirestore.instance
                                                    .collection("Comercio")
                                                    .doc(idCategoria)
                                                    .collection("Comercios")
                                                    .doc(idComercio)
                                                    .get();

                                                if (comercioSnapshot.exists) {
                                                  Map<String, dynamic> comercioData = comercioSnapshot.data() as Map<String, dynamic>;

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => DetailPageComercio(comercio: comercioData),
                                                    ),
                                                  );
                                                } else {
                                                  // Manejar caso en el que el comercio no existe
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: const Text("Error"),
                                                      content: const Text("El comercio no existe."),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: const Text("Aceptar"),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
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
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  "Oferta Comercial",
                  style: TextStyle(
                    fontSize: 35,
                    color: Color.fromRGBO(129, 135, 153, 1),
                    fontFamily: "Medium",
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // StreamBuilder para la subcolección "Categorías" del municipio seleccionado
              SizedBox(
                height: MediaQuery.of(context).size.height + 110,
                child: selectedId == null
                    ? const Center(
                  child: Text("No se encuentra ningún comercio en este municipio."),
                )
                    : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Municipios")
                      .doc(selectedId)
                      .collection("Categorias")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot>? categorias = snapshot.data?.docs;

                      if (categorias == null || categorias.isEmpty) {
                        // Si no hay categorías, muestra un mensaje
                        return const Center(
                          child: Text("No se encuentra ningún comercio en este municipio."),
                        );
                      } else {
                        // Si hay categorías, muestra el GridView con las tarjetas
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: categorias.length,
                            itemBuilder: (context, index) {
                              var categoria = categorias[index];
                              String nombre = categoria["Nombre"];
                              String imagenUrl = categoria["ImagenCard"];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VistaCategoria(idCategoria: categoria.id),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 5.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        imagenUrl,
                                        width: MediaQuery.of(context).size.width,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        nombre,
                                        style: const TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
