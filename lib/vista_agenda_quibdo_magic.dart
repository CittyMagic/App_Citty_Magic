import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";

class VistaAgenda extends StatefulWidget {
  const VistaAgenda({super.key});

  @override
  State<VistaAgenda> createState() => _VistaAgendaState();
}

class _VistaAgendaState extends State<VistaAgenda> {
  TextEditingController _textEditingController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> searchResults = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void searchInFirebase(String query) {
    _firestore
        .collectionGroup("Agenda")
        .where("Nombre", isGreaterThanOrEqualTo: query)
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        searchResults = snapshot.docs
            .map((DocumentSnapshot document) => document["Nombre"].toString())
            .toList();
      });
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
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 400,
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
                              "Descubre los mejores eventos de tu ciudad",
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
                                        borderRadius:
                                            BorderRadius.circular(50),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                      hintText: "Ej: Concierto, Evento...",
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Regular',
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {});
                                      searchInFirebase(value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: _textEditingController
                                        .text.isNotEmpty,
                                    child: Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: searchResults.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title:
                                                  Text(searchResults[index]),
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "NUESTRA AGENDA CIUDAD",
                  style: TextStyle(
                    color: Color.fromRGBO(129, 135, 153, 1),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Próximos Eventos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: "Bold",
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Agenda")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot>? eventos = snapshot.data?.docs;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: eventos?.length ?? 0,
                        itemBuilder: (context, index) {
                          var evento = eventos![index];
                          String nombre = evento["Nombre"];
                          String imagenUrl = evento["ImagenUrl"];
                          String lugar = evento["Lugar"];
                          String descripcion = evento["Descripcion"];
                          Timestamp fecha = evento["Fecha"];
                          String cover = evento["Cover"];
                          return GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.height,
                              child: Card(
                                elevation: 5.0,
                                color: Colors.black,
                                margin: const EdgeInsets.only(top: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      imagenUrl,
                                      width: MediaQuery.of(context).size.width,
                                      height: 250,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15, top: 2),
                                      child: Text(
                                        nombre,
                                        style: const TextStyle(
                                          fontFamily: 'Medium',
                                          fontSize: 20,
                                          color: Color.fromRGBO(129, 135, 153, 1),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15, top: 2),
                                      child: Text(
                                        descripcion,
                                        style: const TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15, top: 2),
                                      child: Text(
                                        lugar,
                                        style: const TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15, top: 2),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            DateFormat("dd-MM-yyyy - hh:mm a")
                                                .format(
                                              fecha.toDate(),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15, top: 2),
                                      child: Text(
                                        cover,
                                        style: const TextStyle(
                                          fontFamily: 'Bold',
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
