import 'package:cittyquibdo/DetailPageComercio.dart';
import 'package:cittyquibdo/VistaCategoria.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VistaComercioQuibdo extends StatefulWidget {
  const VistaComercioQuibdo({Key? key}) : super(key: key);

  @override
  State<VistaComercioQuibdo> createState() => _VistaComercioQuibdoState();
}

class _VistaComercioQuibdoState extends State<VistaComercioQuibdo> {
  TextEditingController _textEditingController = TextEditingController();
  List searchResults = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void searchInFirebase(String query) async {
    //Convertir la consulta a minúscula
    String formattedQuery = query.toLowerCase();

    final comercioSnapshot =
        await FirebaseFirestore.instance.collection("Comercio").get();

    List<Map<String, dynamic>> allResults = [];

    for (final categoriaDoc in comercioSnapshot.docs) {
      final comerciosSnapshot =
          await categoriaDoc.reference.collection("Comercios").get();

      for (final comercioDoc in comerciosSnapshot.docs) {
        Map<String, dynamic> comercioData = comercioDoc.data();

        if ((comercioData.containsKey("Nombre") &&
            comercioData["Nombre"] != null &&
            comercioData["Nombre"].toLowerCase().contains(formattedQuery)) ||
            (comercioData.containsKey("Clave") &&
                comercioData["Clave"] != null &&
                comercioData["Clave"].toLowerCase().contains(formattedQuery))) {
          allResults.add({
            "Nombre": comercioData["Nombre"],
            "idComercio": comercioDoc.id,
            "idCategoria": categoriaDoc.id
          });
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
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: const Image(
                image: AssetImage("assets/Logo/Logo_Blanco.png"),
                width: 125,
                height: 80,
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
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/banner-citty2.jpg"),
                      fit: BoxFit.cover),
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
                                fontSize: 35,
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
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          vertical: 9),
                                    ),
                                    onChanged: (query) {
                                      setState(() {});
                                      searchInFirebase(query);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible:
                                        _textEditingController.text.isNotEmpty,
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
                                                  const Icon(
                                                      Icons.search_sharp),
                                                  const SizedBox(width: 15),
                                                  Text(searchResults[index]
                                                          ["Nombre"] ??
                                                      ""),
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

                                                  // Verificar si hay datos en el snapshot antes de convertirlos
                                                  if (comercioSnapshot.exists) {
                                                    Map<String, dynamic> comercioData =
                                                    comercioSnapshot.data() as Map<String, dynamic>;

                                                    // Navegar a la página de detalles del comercio pasando los datos del comercio como argumento
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => DetailPageComercio(comercio: comercioData),
                                                      ),
                                                    );
                                                  } else {
                                                    // Manejar caso en el que el comercio no existe
                                                    // Por ejemplo, mostrar un mensaje de error
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text("Error"),
                                                        content: Text("El comercio no existe."),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: Text("Aceptar"),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }
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
              SizedBox(
                height: MediaQuery.of(context).size.height + 110,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Comercio")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot>? tiposComercio =
                          snapshot.data?.docs;
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
                          itemCount: tiposComercio?.length ?? 0,
                          itemBuilder: (context, index) {
                            var tipoComercio = tiposComercio![index];
                            String nombre = tipoComercio["Nombre"];
                            String imagenUrl = tipoComercio["ImagenUrl"];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VistaCategoria(
                                        idCategoria: tipoComercio.id),
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
                                    const SizedBox(
                                      height: 3,
                                    ),
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
