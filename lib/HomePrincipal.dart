import 'package:cittyquibdo/DetailPageSitio.dart';
import 'package:cittyquibdo/VistaCittyMagic.dart';
import 'package:cittyquibdo/VistaMunicipioMagic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Map<String, dynamic> Turismo = {
    "01": {
      "Nombre": "Chocó",
      "Municipios": {
        '01': {
          "Nombre": "Quibdó",
          "Sitios": {
            "01": "Tutunendo",
            '02': "Río Ichó",
            '03': "Malecón",
          },
        },
        '02': {
          "Nombre": "Tadó",
          "Sitios": {
            "01": "Bochoromá",
            '02': "Tadosito",
            '03': "Mumbú",
          },
        },
        '03': {
          "Nombre": "Nuquí",
          "Sitios": {
            "01": "Jovi",
            '02': "Arusi",
          },
        },
        '04': {
          "Nombre": "Capurgana",
          "Sitios": {
            "01": "La Coquerita",
            '02': "Playa Aguacate",
            '03': "Cabo Tiburón",
            "04": "La Miel",
            "05": "Playa Soledad",
          },
        },
        '05': {
          "Nombre": "Triganá",
        },
        '06': {
          "Nombre": "Sapzurro",
          "Sitios": {
            "01": "Bahía Sapzurro",
          },
        },
        '07': {
          "Nombre": "Bahía Solano",
          "Sitios": {
            "01": "El Valle",
            '02': "Huina",
            '03': "Mecana",
          },
        },
      },
    },
    "02": {
      "Nombre": "Antioquia",
      "Municipios": {
        '01': {
          "Nombre": "Guatapé",
        },
        '02': {
          "Nombre": "Medellín",
        },
        '03': {
          "Nombre": "Santa Fe de Antioquia",
        },
      },
    },
    "03": {
      "Nombre": "Cafeterero",
    },
    "04": {
      "Nombre": "Caribe",
      "Municipios": {
        '01': {
          "Nombre": "Santa Marta",
        },
        '02': {
          "Nombre": "San Andrés",
        },
        '03': {
          "Nombre": "Cartagena",
        },
      },
    },
    "05": {
      "Nombre": "Urabá",
    },
  };

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        // No es necesario realizar ninguna acción aquí
      });
    });
  }

  // Función para buscar en el diccionario Turismo
  List<Map<String, dynamic>> buscarEnTurismo(
      Map<String, dynamic> turismo, String query) {
    List<Map<String, dynamic>> resultados = [];
    // Itera sobre las regiones
    turismo.forEach((idTurismo, region) {
      String nombreRegion = region['Nombre'].toLowerCase();
      // Verifica si el nombre de la región contiene la consulta
      if (nombreRegion.contains(query.toLowerCase())) {
        resultados.add({
          'idTurismo': idTurismo,
          'Nombre': region['Nombre'],
        });
      }
      // Si hay municipios, busca en los municipios
      if (region.containsKey('Municipios')) {
        Map<String, dynamic> municipios = region['Municipios'] as Map<String, dynamic>;
        municipios.forEach((idMunicipio, municipio) {
          String nombreMunicipio = municipio['Nombre'].toLowerCase();
          // Verifica si el nombre del municipio contiene la consulta
          if (nombreMunicipio.contains(query.toLowerCase())) {
            resultados.add({
              'idTurismo': idTurismo,
              'idMunicipio': idMunicipio,
              'Nombre': municipio['Nombre'],
            });
          }
          // Si hay sitios turísticos, busca en los sitios turísticos
          if (municipio.containsKey('Sitios')) {
            Map<String, dynamic> sitios = municipio['Sitios'] as Map<String, dynamic>;
            sitios.forEach((idSitio, nombreSitio) {
              // Verifica si el nombre del sitio turístico contiene la consulta
              if (nombreSitio.toLowerCase().contains(query.toLowerCase())) {
                resultados.add({
                  'idTurismo': idTurismo,
                  'idMunicipio': idMunicipio,
                  'idSitio': idSitio,
                  'Nombre': nombreSitio,
                });
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
                              onChanged: (query) {
                                // Llama a la función buscarEnTurismo
                                // con el diccionario Turismo y la consulta ingresada por el usuario
                                List<Map<String, dynamic>> newResult = buscarEnTurismo(Turismo, query);
                                // Actualiza el estado de resultados con los resultados de la búsqueda
                                setState(() {
                                  resultados = newResult;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
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
                                      return ListTile(
                                        title: Row(
                                          children: [
                                            const Icon(Icons.location_on_outlined),
                                            const SizedBox(width: 15),
                                            Text(resultado["Nombre"] ?? ""),
                                          ],
                                        ),
                                        onTap: () {
                                          // Obtén los IDs de turismo y municipio del resultado
                                          final idTurismo = resultado['idTurismo'];
                                          final idMunicipio = resultado['idMunicipio'];
                                          final idSitio = resultado['idSitio'];

                                          // Navega a la página correspondiente según los IDs
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