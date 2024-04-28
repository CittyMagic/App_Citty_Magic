import 'package:cittyquibdo/DetailPageSitio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VistaMunicipioMagic extends StatefulWidget {
  final String idMunicipio;
  final String idDepartamento;
  const VistaMunicipioMagic(
      {super.key, required this.idMunicipio, required this.idDepartamento});

  @override
  State<VistaMunicipioMagic> createState() => _VistaMunicipioMagicState();
}

class _VistaMunicipioMagicState extends State<VistaMunicipioMagic> {
  TextEditingController _textEditingController = TextEditingController();
  List searchResults = [];
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void searchInFirebase(
      String query, String departmentId, String municipioId) async {
    // Convertir la consulta a minúsculas
    String formattedQuery = query.toLowerCase();

    final turismoSnapshot =
        await FirebaseFirestore.instance.collection("Turismo").get();

    List<Map<String, dynamic>> allResults = [];

    for (final turismoDoc in turismoSnapshot.docs) {
      // Comprobar si el ID de Turismo coincide con el ID del departamento
      if (turismoDoc.id != departmentId) {
        continue; // Si no coincide, continuar con el siguiente documento
      }

      final municipiosSnapshot =
          await turismoDoc.reference.collection("Municipios").get();

      for (final municipioDoc in municipiosSnapshot.docs) {
        // Comprobar si el ID de Turismo coincide con el ID del departamento
        if (municipioDoc.id != municipioId) {
          continue; // Si no coincide, continuar con el siguiente documento
        }

        final sitiosSnapshot = await municipioDoc.reference
            .collection("Sitios")
            .where("Nombre")
            .get()
            .catchError((error) {
          return null;
        });

        // Verificar si la subcolección 'Sitios' existe antes de continuar
        for (final sitioDoc in (sitiosSnapshot.docs)) {
          Map<String, dynamic> sitioData = sitioDoc.data();

          // Verificar si el nombre o la clave del sitio contiene la consulta
          if ((sitioData.containsKey("Nombre") &&
              sitioData["Nombre"] != null &&
              removeDiacritics(sitioData["Nombre"].toLowerCase()).contains(formattedQuery))){              sitioData["idSitio"] = sitioDoc.id;
            sitioData["idMunicipio"] = municipioDoc.id;
            sitioData["idTurismo"] = turismoDoc.id;
            allResults.add(sitioData);
          }
        }
      
        final comidaSnapshot = await municipioDoc.reference
            .collection("Comida")
            .where("Nombre")
            .get()
            .catchError((error) {
          return null;
        });

        for (final comidaDoc in (comidaSnapshot.docs)) {
          Map<String, dynamic> comidaData = comidaDoc.data();

          if ((comidaData.containsKey("Nombre") &&
              comidaData["Nombre"] != null &&
              removeDiacritics(comidaData["Nombre"].toLowerCase()).contains(formattedQuery))) {
            comidaData["idSitio"] = comidaDoc.id;
            comidaData["idMunicipio"] = municipioDoc.id;
            comidaData["idTurismo"] = turismoDoc.id;
            allResults.add(comidaData);
          }
        }
      
        final entretenimientoSnapshot = await municipioDoc.reference
            .collection("Entretenimiento")
            .where("Nombre")
            .get()
            .catchError((error) {
          return null;
        });

        for (final entretenimientoDoc in (entretenimientoSnapshot.docs)) {
          Map<String, dynamic> entretenimientoData =
              entretenimientoDoc.data();

          if ((entretenimientoData.containsKey("Nombre") &&
              entretenimientoData["Nombre"] != null &&
              removeDiacritics(entretenimientoData["Nombre"]
                  .toLowerCase())
                  .contains(formattedQuery))) {
            entretenimientoData["idSitio"] = entretenimientoDoc.id;
            entretenimientoData["idMunicipio"] = municipioDoc.id;
            entretenimientoData["idTurismo"] = turismoDoc.id;
            allResults.add(entretenimientoData);
          }
        }
      
        final cultutaSnapshot = await municipioDoc.reference
            .collection("Cultura")
            .where("Nombre")
            .get()
            .catchError((error) {
          return null;
        });

        for (final culturaDoc in (cultutaSnapshot.docs)) {
          Map<String, dynamic> culturaData = culturaDoc.data();

          if ((culturaData.containsKey("Nombre") &&
              culturaData["Nombre"] != null &&
              removeDiacritics(culturaData["Nombre"].toLowerCase()).contains(formattedQuery))) {
            culturaData["idSitio"] = culturaDoc.id;
            culturaData["idMunicipio"] = municipioDoc.id;
            culturaData["idTurismo"] = turismoDoc.id;
            allResults.add(culturaData);
          }
        }
      
        final informacionSnapshot = await municipioDoc.reference
            .collection("Informacion")
            .where("Nombre")
            .get()
            .catchError((error) {
          return null;
        });

        for (final informacionDoc in (informacionSnapshot.docs)) {
          Map<String, dynamic> informacionData = informacionDoc.data();

          if ((informacionData.containsKey("Nombre") &&
              informacionData["Nombre"] != null &&
              removeDiacritics(informacionData["Nombre"]
                  .toLowerCase())
                  .contains(formattedQuery))) {
            informacionData["idSitio"] = informacionDoc.id;
            informacionData["idMunicipio"] = municipioDoc.id;
            informacionData["idTurismo"] = turismoDoc.id;
            allResults.add(informacionData);
          }
        }
            }
    }

    setState(() {
      searchResults = allResults;
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            color: Colors.transparent,
            child: SizedBox(
              width: 150,
              child: TextFormField(
                controller: _textEditingController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 109, 0, 1),
                      width: 3,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 109, 0, 1),
                      width: 3,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                onChanged: (query) {
                  setState(() {});
                  searchInFirebase(
                      query, widget.idDepartamento, widget.idMunicipio);
                },
              ),
            ),
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
              Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Turismo")
                        .doc(widget.idDepartamento)
                        .collection("Municipios")
                        .doc(widget.idMunicipio)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const SizedBox(height: 0); // No hay datos
                      }
                      final municipioData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final imageUrl = municipioData["ImagenPerfil"];

                      return Stack(
                        children: [
                          SizedBox(
                            child: Image.network(
                              imageUrl,
                              height: 250,
                              fit: BoxFit.fitWidth,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Positioned.fill(
                            top: 55.0,
                            child: Column(
                              children: [
                                // Mostrar los resultados de la búsqueda solo cuando se haya ingresado texto
                                if (_textEditingController.text.isNotEmpty)
                                  Container(
                                    color: Colors
                                        .white60, // Color de fondo para el ListView.builder
                                    height: 200,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      //physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: searchResults.length,
                                      itemBuilder: (context, index) {
                                        final result = searchResults[index];
                                        return ListTile(
                                          title: Row(
                                            children: [
                                              const Icon(
                                                  Icons.location_on_outlined),
                                              Text(
                                                result["Nombre"],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Medium",
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            String idMunicipio =
                                                searchResults[index]
                                                    ["idMunicipio"];
                                            String idTurismo =
                                                searchResults[index]
                                                    ["idTurismo"];
                                            if (searchResults[index]
                                                .containsKey("idSitio")) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPageSitios(
                                                    sitio: searchResults[index],
                                                    IdDepartamento: idTurismo,
                                                    IdMunicipio: idMunicipio,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              // Si es un municipio, navega a la vista de municipio
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VistaMunicipioMagic(
                                                    idMunicipio: idMunicipio,
                                                    idDepartamento: idTurismo,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    color: const Color.fromRGBO(255, 109, 0, 1),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "¿Que hacer?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "Bold",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Turismo")
                        .doc(widget.idDepartamento)
                        .collection("Municipios")
                        .doc(widget.idMunicipio)
                        .collection("Sitios")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }
                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        // Si no hay documentos o si data es null, no mostramos nada
                        return const SizedBox(
                            height: 0); // Altura fija del contenedor
                      }
                      // Si hay documentos en la subcolección "Sitios", mostramos las tarjetas
                      return Column(
                        children: [
                          const SizedBox(height: 15),
                          const Divider(
                            height: 1,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          const Center(
                            child: Text(
                              "Descubre y Explora",
                              style: TextStyle(
                                color: Color.fromRGBO(129, 135, 153, 1),
                                fontSize: 25,
                                fontFamily: 'Medium',
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(
                            height: 10,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 200, // Altura fija del contenedor
                            child: ListView.builder(
                              scrollDirection:
                                  Axis.horizontal, // Scroll horizontal
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot sitios =
                                    snapshot.data!.docs[index];
                                Map<String, dynamic>? sitio =
                                    sitios.data() as Map<String, dynamic>?;

                                // Verificar si sitio es null
                                if (sitio == null) {
                                  // Manejar el caso de datos nulos, como saltar esta iteración
                                  return const SizedBox.shrink();
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPageSitios(
                                            sitio: sitio,
                                            IdDepartamento:
                                                widget.idDepartamento,
                                            IdMunicipio: widget.idMunicipio,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Image.network(
                                            sitio["ImagenUrl"],
                                            fit: BoxFit.cover,
                                            height: 150,
                                            width:
                                                200, // Ancho fijo de las tarjetas
                                          ),
                                          Text(sitio["Nombre"]),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Turismo")
                        .doc(widget.idDepartamento)
                        .collection("Municipios")
                        .doc(widget.idMunicipio)
                        .collection("Entretenimiento")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }

                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        // Si no hay datos o documentos en la subcolección "Entretenimiento", no mostramos nada
                        return const SizedBox(height: 0);
                      }

                      // Si hay documentos en la subcolección "Entretenimiento", mostramos las tarjetas
                      return Column(
                        children: [
                          const SizedBox(height: 5),
                          const Divider(
                            height: 10,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          const Center(
                            child: Text(
                              "Experiencias Vibrantes",
                              style: TextStyle(
                                color: Color.fromRGBO(129, 135, 153, 1),
                                fontSize: 25,
                                fontFamily: 'Medium',
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(
                            height: 10,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot sitios =
                                    snapshot.data!.docs[index];
                                Map<String, dynamic>? sitio =
                                    sitios.data() as Map<String, dynamic>?;

                                // Verificar si 'sitio' es null
                                if (sitio == null) {
                                  // Manejar el caso de datos nulos, como saltar esta iteración
                                  return const SizedBox.shrink();
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPageSitios(
                                            sitio: sitio,
                                            IdDepartamento:
                                                widget.idDepartamento,
                                            IdMunicipio: widget.idMunicipio,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Image.network(
                                            sitio["ImagenUrl"],
                                            fit: BoxFit.cover,
                                            height: 150,
                                            width: 200,
                                          ),
                                          Text(sitio["Nombre"]),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Turismo")
                        .doc(widget.idDepartamento)
                        .collection("Municipios")
                        .doc(widget.idMunicipio)
                        .collection("Comida")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }

                      // Verificar si snapshot.data es nulo o si no tiene documentos
                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return const SizedBox(
                          height: 0,
                        );
                      }

                      // Mostrar las tarjetas si hay documentos en la subcolección "Comida"
                      return Column(
                        children: [
                          const SizedBox(height: 5),
                          const Divider(
                            height: 10,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          const Center(
                            child: Text(
                              "Sabores del Destino",
                              style: TextStyle(
                                color: Color.fromRGBO(129, 135, 153, 1),
                                fontSize: 25,
                                fontFamily: 'Medium',
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(
                            height: 10,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 200, // Altura fija del contenedor
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot sitios =
                                    snapshot.data!.docs[index];
                                Map<String, dynamic>? sitio =
                                    sitios.data() as Map<String, dynamic>?;

                                // Verificar si sitio es nulo
                                if (sitio == null) {
                                  // Manejar el caso de datos nulos
                                  return const SizedBox.shrink();
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPageSitios(
                                            sitio: sitio,
                                            IdDepartamento:
                                                widget.idDepartamento,
                                            IdMunicipio: widget.idMunicipio,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Image.network(
                                            sitio["ImagenUrl"],
                                            fit: BoxFit.cover,
                                            height: 150,
                                            width: 200,
                                          ),
                                          Text(sitio["Nombre"]),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Turismo")
                        .doc(widget.idDepartamento)
                        .collection("Municipios")
                        .doc(widget.idMunicipio)
                        .collection("Cultura")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }

                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        // Si no hay datos o documentos en la subcolección "Cultura", no mostramos nada
                        return const SizedBox(height: 0);
                      }

                      // Mostrar las tarjetas si hay documentos en la subcolección "Cultura"
                      return Column(
                        children: [
                          const SizedBox(height: 5),
                          const Divider(
                            height: 10,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          const Center(
                            child: Text(
                              "Experiencias Culturales",
                              style: TextStyle(
                                color: Color.fromRGBO(129, 135, 153, 1),
                                fontSize: 25,
                                fontFamily: 'Medium',
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(
                            height: 10,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 200, // Altura fija del contenedor
                            child: ListView.builder(
                              scrollDirection:
                                  Axis.horizontal, // Scroll horizontal
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot sitios =
                                    snapshot.data!.docs[index];
                                Map<String, dynamic>? sitio =
                                    sitios.data() as Map<String, dynamic>?;

                                // Verificar si 'sitio' es null
                                if (sitio == null) {
                                  // Manejar el caso de datos nulos
                                  return const SizedBox.shrink();
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPageSitios(
                                            sitio: sitio,
                                            IdDepartamento:
                                                widget.idDepartamento,
                                            IdMunicipio: widget.idMunicipio,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Image.network(
                                            sitio["ImagenUrl"],
                                            fit: BoxFit.cover,
                                            height: 150,
                                            width: 200,
                                          ),
                                          Text(sitio["Nombre"]),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Turismo")
                        .doc(widget.idDepartamento)
                        .collection("Municipios")
                        .doc(widget.idMunicipio)
                        .collection("Informacion")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }

                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        // Si no hay datos o documentos en la subcolección "Informacion", no mostramos nada
                        return const SizedBox(height: 0);
                      }

                      // Mostrar las tarjetas si hay documentos en la subcolección "Informacion"
                      return Column(
                        children: [
                          const SizedBox(height: 5),
                          const Divider(
                            height: 10,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          const Center(
                            child: Text(
                              "Información Útil",
                              style: TextStyle(
                                color: Color.fromRGBO(129, 135, 153, 1),
                                fontSize: 25,
                                fontFamily: 'Medium',
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(
                            height: 10,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 200, // Altura fija del contenedor
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot sitios =
                                    snapshot.data!.docs[index];
                                Map<String, dynamic>? sitio =
                                    sitios.data() as Map<String, dynamic>?;

                                // Verificar si 'sitio' es null
                                if (sitio == null) {
                                  // Manejar el caso de datos nulos
                                  return const SizedBox.shrink();
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPageSitios(
                                            sitio: sitio,
                                            IdDepartamento:
                                                widget.idDepartamento,
                                            IdMunicipio: widget.idMunicipio,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Image.network(
                                            sitio["ImagenUrl"],
                                            fit: BoxFit.cover,
                                            height: 150,
                                            width: 200,
                                          ),
                                          Text(sitio["Nombre"]),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Turismo")
                        .doc(widget.idDepartamento)
                        .collection("Municipios")
                        .doc(widget.idMunicipio)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const SizedBox(height: 0); // No hay datos
                      }
                      final municipioData =
                      snapshot.data!.data() as Map<String, dynamic>;
                     /* final mapaGeoPoint = municipioData["Mapa"] as GeoPoint;
                      final mapa = LatLng(mapaGeoPoint.latitude, mapaGeoPoint.longitude);*/
                      final ubicacion = municipioData["Ubicacion"];

                      return Column(
                        children: [
                          const SizedBox(height: 5),
                          const Divider(
                            height: 10,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              ubicacion,
                              style: const TextStyle(
                                color: Color.fromRGBO(129, 135, 153, 1),
                                fontSize: 25,
                                fontFamily: 'Medium',
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(
                            height: 10,
                            indent: 70,
                            endIndent: 70,
                            color: Color.fromRGBO(129, 135, 153, 1),
                            thickness: 5,
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: const CameraPosition(
                                  target: LatLng(5.6934391,-76.6610421),
                                zoom: 13.0,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
