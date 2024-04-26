import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailPageComercio extends StatefulWidget {
  final idDepartamento;
  final idMunicipio;
  final Map<String, dynamic> comercio;
  const DetailPageComercio({super.key, required this.comercio, this.idDepartamento, this.idMunicipio});

  @override
  State<DetailPageComercio> createState() => _DetailPageComercioState();
}

class _DetailPageComercioState extends State<DetailPageComercio> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> imagenes = widget.comercio["Imagenes"];
    String selectedInfo = "";

    void updateSelectedInfo(String newInfo) {
      setState(() {
        selectedInfo = newInfo;
      });
    }

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
          child: Padding(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                CarouselSlider(
                  items: imagenes.map((imagenUrl) {
                    return Image.network(
                      imagenUrl,
                      width: 400,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 300.0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.comercio["Nombre"],
                        style: const TextStyle(
                          fontFamily: "Medium",
                          fontSize: 25,
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
                const SizedBox(height: 5),
                Text(
                  widget.comercio["Descripcion"],
                  style: const TextStyle(
                    color: Color.fromRGBO(129, 135, 153, 1),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          const Size(130, 30),
                        ),
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide.none),
                        ),
                      ),
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.shareNodes,
                            color: Colors.black,
                            size: 12,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Compartir",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          const Size(130, 20),
                        ),
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide.none),
                        ),
                      ),
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.black,
                            size: 12,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Favorito",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(
                  color: Color.fromRGBO(129, 135, 153, 1),
                  indent: 12,
                  height: 1,
                  endIndent: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide.none),
                              ),
                            ),
                            onPressed: () {
                              updateSelectedInfo("Detalle");
                            },
                            child: const Text("Detalle"),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide.none),
                              ),
                            ),
                            onPressed: () {
                              updateSelectedInfo("Comentarios");
                            },
                            child: const Text("Comentarios"),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide.none),
                              ),
                            ),
                            onPressed: () {
                              updateSelectedInfo("Contacto Info");
                            },
                            child: const Text("Contacto Info"),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide.none),
                              ),
                            ),
                            onPressed: () {
                              updateSelectedInfo("Eventos");
                            },
                            child: const Text("Eventos"),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Color.fromRGBO(129, 135, 153, 1),
                        indent: 12,
                        height: 1,
                        endIndent: 12,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 75,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.grey[200],
                        ),
                        child: Text(
                          selectedInfo.isNotEmpty
                              ? selectedInfo
                              : "Seleccione un botón para ver la información",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                ExpansionTile(
                  title: const Text("Horario"),
                  children: [
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Lunes"),
                              Spacer(),
                              Text("04:00 PM - 11:30 PM")
                            ],
                          ),
                        ),
                        const Divider(
                          color: Color.fromRGBO(129, 135, 153, 1),
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Martes"),
                              Spacer(),
                              Text("04:00 PM - 11:30 PM")
                            ],
                          ),
                        ),
                        const Divider(
                          color: Color.fromRGBO(129, 135, 153, 1),
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Miercoles"),
                              Spacer(),
                              Text("04:00 PM - 11:30 PM")
                            ],
                          ),
                        ),
                        const Divider(
                          color: Color.fromRGBO(129, 135, 153, 1),
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Jueves"),
                              Spacer(),
                              Text("04:00 PM - 11:30 PM")
                            ],
                          ),
                        ),
                        const Divider(
                          color: Color.fromRGBO(129, 135, 153, 1),
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Viernes"),
                              Spacer(),
                              Text("04:00 PM - 11:30 PM")
                            ],
                          ),
                        ),
                        const Divider(
                          color: Color.fromRGBO(129, 135, 153, 1),
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Sabados"),
                              Spacer(),
                              Text("04:00 PM - 11:30 PM")
                            ],
                          ),
                        ),
                        const Divider(
                          color: Color.fromRGBO(129, 135, 153, 1),
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Domingos"),
                              Spacer(),
                              Text("04:00 PM - 11:30 PM")
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.grey,
                        child: const Text(
                          "Como Llegar",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          "https://motor.elpais.com/wp-content/uploads/2022/01/google-maps-22.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide.none),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          widget.comercio["Direccion"],
                          style: const TextStyle(
                            color: Color.fromRGBO(129, 135, 153, 1),
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide.none),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          widget.comercio["Telefono"],
                          style: const TextStyle(
                            color: Color.fromRGBO(129, 135, 153, 1),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.squareFacebook,
                              color: Color.fromRGBO(129, 135, 153, 1),
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.instagram,
                              color: Color.fromRGBO(129, 135, 153, 1),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
