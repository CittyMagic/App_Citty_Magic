import 'package:cittyquibdo/DetailPageSitio.dart';
import 'package:cittyquibdo/VistaCittyMagic.dart';
import 'package:cittyquibdo/VistaMunicipioMagic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class HomePrincipal extends StatefulWidget {
  const HomePrincipal({super.key});

  @override
  State<HomePrincipal> createState() => _HomePrincipalState();
}

class _HomePrincipalState extends State<HomePrincipal> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> resultados = [];
  bool isLoading = false;
  // Crea un diccionario vacío
  Map<String, dynamic> turismoCollection = {};

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Llama a la función para cargar los datos de Firestore
    mostrarNombresTurismoMunicipiosSitios();
    _focusNode.addListener(() {
      setState(() {
        // No es necesario realizar ninguna acción aquí
      });
    });
  }

  Future<void> mostrarNombresTurismoMunicipiosSitios() async {
    // Accede a la colección "Turismo" en Firestore
    CollectionReference turismoCollectionRef = FirebaseFirestore.instance.collection('Turismo');

    // Obtén los documentos de la colección "Turismo"
    QuerySnapshot turismoSnapshot = await turismoCollectionRef.get();

    // Recorre cada documento en la colección "Turismo"
    for (QueryDocumentSnapshot turismoDoc in turismoSnapshot.docs) {
      // Obtén los datos del documento "Turismo"
      Map<String, dynamic>? turismoData = turismoDoc.data() as Map<String, dynamic>?;

      // Almacena los datos de "Turismo" en el diccionario
      if (turismoData != null) {
        turismoCollection[turismoDoc.id] = turismoData;

        // Crea un diccionario para almacenar los municipios
        Map<String, dynamic> municipiosDict = {};

        // Accede a la subcolección "Municipios" del documento actual
        CollectionReference municipiosRef = turismoDoc.reference.collection('Municipios');

        // Obtén los documentos de la subcolección "Municipios"
        QuerySnapshot municipiosSnapshot = await municipiosRef.get();

        // Recorre cada documento en la subcolección "Municipios"
        for (QueryDocumentSnapshot municipioDoc in municipiosSnapshot.docs) {
          // Obtén los datos del documento "Municipios"
          Map<String, dynamic>? municipioData = municipioDoc.data() as Map<String, dynamic>?;

          // Almacena los datos de "Municipios" en el diccionario de municipios
          if (municipioData != null) {
            // Crea un diccionario para almacenar los sitios turísticos
            Map<String, dynamic> sitiosDict = {};

            // Accede a la subcolección "Sitios" del documento actual en "Municipios"
            CollectionReference sitiosRef = municipioDoc.reference.collection('Sitios');

            // Obtén los documentos de la subcolección "Sitios"
            QuerySnapshot sitiosSnapshot = await sitiosRef.get();

            // Recorre cada documento en la subcolección "Sitios"
            for (QueryDocumentSnapshot sitioDoc in sitiosSnapshot.docs) {
              // Obtén los datos del documento "Sitios"
              Map<String, dynamic>? sitioData = sitioDoc.data() as Map<String, dynamic>?;
              // Almacena los datos de "Sitios" en el diccionario de sitios
              if (sitioData != null) {
                sitiosDict[sitioDoc.id] = sitioData;
              }
            }
            // Almacena el diccionario de sitios en el diccionario de municipios
            municipioData['Sitios'] = sitiosDict;
          }
          // Almacena el diccionario de municipios en el diccionario de turismo
          municipiosDict[municipioDoc.id] = municipioData;
        }

        // Almacena el diccionario de municipios en el diccionario de turismo
        turismoCollection[turismoDoc.id]['Municipios'] = municipiosDict;
      }
    }
  }

  // Función para buscar en el diccionario Turismo
  List<Map<String, dynamic>> buscarEnTurismo(Map<String, dynamic> turismoCollection, String query) {
    List<Map<String, dynamic>> resultados = [];
    // Itera sobre las regiones
    turismoCollection.forEach((idTurismo, region) {
      // Verifica que la clave 'Nombre' esté presente y sea una cadena
      if (region.containsKey('Nombre') && region['Nombre'] is String) {
        String nombreRegion = region['Nombre'] as String;
        // Verifica si el nombre de la región contiene la consulta
        if (removeDiacritics(nombreRegion.toLowerCase()).contains(query.toLowerCase())) {
          resultados.add({
            'idTurismo': idTurismo,
            'Nombre': region['Nombre'],
          });
        }
      }

      // Si hay municipios, busca en los municipios
      if (region.containsKey('Municipios')) {
        Map<String, dynamic> municipios = region['Municipios'] as Map<String, dynamic>;
        municipios.forEach((idMunicipio, municipio) {
          // Verifica que la clave 'Nombre' esté presente y sea una cadena
          if (municipio.containsKey('Nombre') && municipio['Nombre'] is String) {
            String nombreMunicipio = municipio['Nombre'] as String;
            // Verifica si el nombre del municipio contiene la consulta
            if (removeDiacritics(nombreMunicipio.toLowerCase()).contains(query.toLowerCase())) {
              resultados.add({
                'idTurismo': idTurismo,
                'idMunicipio': idMunicipio,
                'Nombre': municipio['Nombre'],
              });
            }
          }

          // Si hay sitios turísticos, busca en los sitios turísticos
          if (municipio.containsKey('Sitios')) {
            Map<String, dynamic> sitios = municipio['Sitios'] as Map<String, dynamic>;
            sitios.forEach((idSitio, datosSitio) {
              // Verifica que la clave 'Nombre' esté presente y sea una cadena
              if (datosSitio.containsKey('Nombre') && datosSitio['Nombre'] is String) {
                String nombreSitio = datosSitio['Nombre'] as String;
                // Verifica si el nombre del sitio contiene la consulta
                if (removeDiacritics(nombreSitio.toLowerCase()).contains(query.toLowerCase())) {
                  resultados.add({
                    'idTurismo': idTurismo,
                    'idMunicipio': idMunicipio,
                    'idSitio': idSitio,
                    'Nombre': nombreSitio,
                  });
                }
              }
            });
          }
        });
      }
    });
    return resultados;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/banner-citty1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.black54,
                body: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 120),
                      const Text(
                        "Descubre Colombia",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: 'ExtraBold',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        color: Colors.transparent,
                        height: 200,
                        width: 325,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _textEditingController,
                              focusNode: _focusNode,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
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
                                  size: 25,
                                ),
                                hintText: !_focusNode.hasFocus &&
                                    _textEditingController.text.isEmpty
                                    ? "Ej: Quibdó, Guatapé, Medellín"
                                    : null,
                                hintStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Regular',
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 9, horizontal: 10),
                              ),
                              // Llama a la función buscarEnTurismo con el diccionario Turismo y la consulta ingresada por el usuario
                              onChanged: (query) {
                                // Realiza la búsqueda
                                List<Map<String, dynamic>> newResult = buscarEnTurismo(turismoCollection, query);

                                // Actualiza el estado de resultados con los resultados de la búsqueda
                                setState(() {
                                  resultados = newResult;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            // Widget Visibility
                            Visibility(
                              visible: _textEditingController.text.isNotEmpty,
                              child: Expanded(
                                child: Container(
                                  color: Colors.white70,
                                  width: 325,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: resultados.length,
                                    itemBuilder: (context, index) {
                                      final resultado = resultados[index];
                                      // Verifica que la clave 'Nombre' esté presente
                                      final nombre = resultado['Nombre'] != null ? resultado['Nombre'] : 'Sin nombre';

                                      return ListTile(
                                        title: Row(
                                          children: [
                                            const Icon(Icons.location_on_outlined),
                                            const SizedBox(width: 15),
                                            Text(nombre),
                                          ],
                                        ),
                                        onTap: () {
                                          // Obtén los IDs de turismo, municipio y sitio
                                          final idTurismo = resultado['idTurismo'];
                                          final idMunicipio = resultado['idMunicipio'];
                                          final idSitio = resultado['idSitio'];

                                          // Verifica la navegación según los IDs
                                          if (idSitio != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailPageSitios(
                                                      sitio: resultado,
                                                      IdDepartamento: idTurismo,
                                                      IdMunicipio: idMunicipio,
                                                    ),
                                              ),
                                            );
                                            print(resultado);
                                          } else if (idMunicipio != null) {
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
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    VistaCityMagic(
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection("Turismo").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                // Verificación de nulos y longitud de documentos
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Text("No hay datos disponibles");
                }
                // Calcular la altura basada en la cantidad de documentos
                double containerHeight = snapshot.data!.docs.length * 155.0;
                return SizedBox(
                  height: containerHeight,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: snapshot.data!.docs.map(
                          (DocumentSnapshot departamentos) {
                        Map<String, dynamic> departamento =
                        departamentos.data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VistaCityMagic(idDepartamento: departamentos.id),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              children: [
                                Image.network(
                                  departamento["ImagenUrl"],
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}