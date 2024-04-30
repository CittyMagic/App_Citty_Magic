import 'package:cittyquibdo/DetailPageSitio.dart';
import 'package:cittyquibdo/VistaMunicipioMagic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class VistaCityMagic extends StatefulWidget {
  final String idDepartamento;

  const VistaCityMagic({super.key, required this.idDepartamento});

  @override
  State<VistaCityMagic> createState() => _VistaCityMagicState();
}

class _VistaCityMagicState extends State<VistaCityMagic> {
  TextEditingController _textEditingController = TextEditingController();
  List searchResults = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void searchInFirebase(String query, String departmentId) async {
    // Convertir la consulta a minúsculas
    String formattedQuery = removeDiacritics(query.toLowerCase());

    final turismoSnapshot =
        await FirebaseFirestore.instance.collection("Turismo").get();

    List<Map<String, dynamic>> allResults = [];

    for (final turismoDoc in turismoSnapshot.docs) {
      // Comprobar si el ID de Turismo coincide con el ID del departamento
      if (turismoDoc.id != departmentId) {
        continue; // Si no coincide, continuar con el siguiente documento
      }

      final municipiosSnapshot = await turismoDoc.reference
          .collection("Municipios")
          .where("Nombre")
          .get();

      for (final municipioDoc in municipiosSnapshot.docs) {
        // Los pasos siguientes de búsqueda y agregación de resultados seguirían igual que en tu código original
        // pero ahora solo se aplica a los documentos dentro del ID de departamento específico.
        Map<String, dynamic> municipioData = municipioDoc.data();

        // Verificar si el nombre del municipio contiene la consulta
        if (municipioData.containsKey("Nombre") &&
            municipioData["Nombre"] != null &&
            removeDiacritics(municipioData["Nombre"].toLowerCase()).contains(formattedQuery)) {
          allResults.add({
            "Nombre":
                municipioData["Nombre"], // Agregar el nombre del municipio
            "idMunicipio": municipioDoc.id,
            "idTurismo": turismoDoc.id,
          });
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
              removeDiacritics(sitioData["Nombre"].toLowerCase()).contains(formattedQuery))) {
            sitioData["idSitio"] = sitioDoc.id;
            sitioData["idMunicipio"] = municipioDoc.id;
            sitioData["idTurismo"] = turismoDoc.id;
            allResults.add(sitioData);
          }
        }
      /*
        final comidaSnapshot = await municipioDoc.reference
            .collection("Comida")
            .where("Nombre")
            .get()
            .catchError((error) {
          return null;
        });

        if (comidaSnapshot != null) {
          for (final comidaDoc in (comidaSnapshot.docs)) {
            Map<String, dynamic> comidaData = comidaDoc.data();

            if ((comidaData.containsKey("Nombre") &&
                comidaData["Nombre"] != null &&
                comidaData["Nombre"].toLowerCase().contains(formattedQuery))) {
              comidaData["idSitio"] = comidaDoc.id;
              comidaData["idMunicipio"] = municipioDoc.id;
              comidaData["idTurismo"] = turismoDoc.id;
              allResults.add(comidaData);
            }
          }
        }

        final entretenimientoSnapshot = await municipioDoc.reference
            .collection("Entretenimiento")
            .where("Nombre")
            .get()
            .catchError((error) {
          return null;
        });

        if (entretenimientoSnapshot != null) {
          for (final entretenimientoDoc in (entretenimientoSnapshot.docs)) {
            Map<String, dynamic> entretenimientoData =
                entretenimientoDoc.data();

            if ((entretenimientoData.containsKey("Nombre") &&
                entretenimientoData["Nombre"] != null &&
                entretenimientoData["Nombre"]
                    .toLowerCase()
                    .contains(formattedQuery))) {
              entretenimientoData["idSitio"] = entretenimientoDoc.id;
              entretenimientoData["idMunicipio"] = municipioDoc.id;
              entretenimientoData["idTurismo"] = turismoDoc.id;
              allResults.add(entretenimientoData);
            }
          }
        }

        final cultutaSnapshot = await municipioDoc.reference
            .collection("Cultura")
            .where("Nombre")
            .get()
            .catchError((error) {
          return null;
        });

        if (cultutaSnapshot != null) {
          for (final culturaDoc in (cultutaSnapshot.docs)) {
            Map<String, dynamic> culturaData = culturaDoc.data();

            if ((culturaData.containsKey("Nombre") &&
                culturaData["Nombre"] != null &&
                culturaData["Nombre"].toLowerCase().contains(formattedQuery))) {
              culturaData["idSitio"] = culturaDoc.id;
              culturaData["idMunicipio"] = municipioDoc.id;
              culturaData["idTurismo"] = turismoDoc.id;
              allResults.add(culturaData);
            }
          }
        }

        final informacionSnapshot = await municipioDoc.reference
            .collection("Informacion")
            .where("Nombre")
            .get()
            .catchError((error) {
          return null;
        });

        if (informacionSnapshot != null) {
          for (final informacionDoc in (informacionSnapshot.docs)) {
            Map<String, dynamic> informacionData = informacionDoc.data();

            if ((informacionData.containsKey("Nombre") &&
                informacionData["Nombre"] != null &&
                informacionData["Nombre"]
                    .toLowerCase()
                    .contains(formattedQuery))) {
              informacionData["idSitio"] = informacionDoc.id;
              informacionData["idMunicipio"] = municipioDoc.id;
              informacionData["idTurismo"] = turismoDoc.id;
              allResults.add(informacionData);
            }
          }
        }*/
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
    return MaterialApp(
      home: Scaffold(
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
                    searchInFirebase(query, widget.idDepartamento);
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
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Turismo")
                      .doc(widget.idDepartamento)
                      .collection("Municipios")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    // Manejo de datos nulos
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Obtener la lista de documentos de municipios
                    List<DocumentSnapshot> municipios = snapshot.data!.docs;
                    // Verifica los valores nulos en municipios y municipioData
                    if (municipios.isEmpty) {
                      return const Center(
                          child: Text("No hay municipios disponibles"));
                    }
                    // Calcular la altura basada en la cantidad de municipios
                    double containerHeight =
                        municipios.length * 155.0; // Altura de cada tarjeta
                    return Column(
                      children: [
                        Stack(
                          children: [
                            // Colocar la imagen del primer municipio en la parte inferior
                            Image.network(
                              municipios.isNotEmpty
                                  ? municipios.first.get("Imagen") ?? ""
                                  : "",
                              fit: BoxFit.cover,
                              height: 400,
                              width: MediaQuery.of(context).size.width,
                            ),
                            // Colocar la ventana de resultados encima de la imagen
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 55),
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
                                                        fontFamily: "Medium"),
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
                            ),
                          ],
                        ),
                        // Mostrar la lista de municipios
                        SizedBox(
                          height: containerHeight,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children:
                                municipios.map((DocumentSnapshot municipio) {
                              Map<String, dynamic> municipioData =
                                  municipio.data() as Map<String, dynamic>;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VistaMunicipioMagic(
                                        idMunicipio: municipio.id,
                                        idDepartamento: widget.idDepartamento,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Column(
                                    children: [
                                      Image.network(
                                        municipioData["ImagenUrl"],
                                        fit: BoxFit.cover,
                                        height: 150,
                                        width: double.infinity,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }
}