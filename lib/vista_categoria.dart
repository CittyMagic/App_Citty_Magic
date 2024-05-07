import 'package:cittyquibdo/detail_page_comercio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class VistaCategoria extends StatefulWidget {
  final String idCategoria;

  const VistaCategoria({super.key, required this.idCategoria});

  @override
  State<VistaCategoria> createState() => _VistaCategoriaState();
}

class _VistaCategoriaState extends State<VistaCategoria> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
              SizedBox(
                child: Image(
                  image: const AssetImage("assets/Restaurante.png"),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Comercio")
                      .doc(widget.idCategoria)
                      .collection("Comercios")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var comercio = snapshot.data?.docs[index].data(); // Obtener los datos del comercio
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPageComercio(comercio: comercio as Map<String, dynamic>),

                              ),
                            );
                          },
                          child: _buildComercioCard(comercio! as Map<String, dynamic>),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComercioCard(Map<String, dynamic> comercio) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListBody(
          children: [
            Image.network(
              comercio["ImagenUrl"],
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Text(
                    comercio["Nombre"],
                    style: const TextStyle(
                      fontFamily: "Medium",
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.verified,
                    color: Colors.blue,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green, // Color del borde
                        width: 1.5, // Ancho del borde
                      ),
                      // borderRadius: BorderRadius.circular(5.0), // Radio del borde
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmoothStarRating(
                          rating: comercio["Ranking"] != null
                              ? comercio["Ranking"].toDouble()
                              : 0.0,
                          size: 20,
                          filledIconData: Icons.star,
                          defaultIconData: Icons.star_border,
                          halfFilledIconData: Icons.star_half,
                          color: Colors.green,
                          borderColor: Colors.green,
                          starCount: 5,
                          allowHalfRating: true,
                          spacing: 2.0,
                        ),
                        const SizedBox(width: 5),
                        Container(
                          color: Colors.green,
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: Text(
                            comercio["Ranking"] != null
                                ? double.parse(comercio["Ranking"].toString())
                                    .toString()
                                : "0.0",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      Text(comercio["Ubicacion"]),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height:10),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                comercio["Clave"],
                style: const TextStyle(
                  fontFamily: "Medium",
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    fixedSize: WidgetStateProperty.all(
                      const Size(190, 30),
                    ),
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide.none,
                      ),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        color: Color.fromRGBO(129, 135, 153, 1),
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Llamar",
                        style: TextStyle(
                          color: Color.fromRGBO(129, 135, 153, 1),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    fixedSize: WidgetStateProperty.all(
                      const Size(190, 20),
                    ),
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide.none),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color.fromRGBO(129, 135, 153, 1),
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Mapa",
                        style: TextStyle(
                          color: Color.fromRGBO(129, 135, 153, 1),
                          fontSize: 14,
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
    );
  }
}
