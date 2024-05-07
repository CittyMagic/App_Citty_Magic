import 'package:cittyquibdo/vista_citty_magic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VistaTurismo extends StatefulWidget {
  const VistaTurismo({super.key});

  @override
  State<VistaTurismo> createState() => _VistaTurismoState();
}

class _VistaTurismoState extends State<VistaTurismo> {
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
        .collection("SitiosTuristicos")
        .where("Titulo", isGreaterThanOrEqualTo: query)
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        searchResults = snapshot.docs
            .map((DocumentSnapshot document) => document["Titulo"].toString())
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
                width: 400,
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/banner-citty1.jpg"),
                      fit: BoxFit.cover),
                ),
                child: Scaffold(
                  backgroundColor: Colors.black54,
                  body: Center(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 120),
                            const Text(
                              "Descubre Colombia",
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                fontFamily: 'ExtraBold',
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
                                      hintText: "Ej: Playa, Natural, Aventura",
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
                                    visible:
                                        _textEditingController.text.isNotEmpty,
                                    child: Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: searchResults.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(searchResults[index]),
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
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Turismo")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.hasError}");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var departamento = snapshot.data?.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VistaCityMagic(
                                    idDepartamento: departamento.id),
                              ),
                            );
                          },
                          child: _buildTurismoCard(departamento!),
                        );
                      },
                    );
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

  Widget _buildTurismoCard(DocumentSnapshot departamento) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: ListBody(
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
  }
}
