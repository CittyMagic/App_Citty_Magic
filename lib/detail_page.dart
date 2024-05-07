import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/iglesia1.jpg"))),
        child: Scaffold(
          backgroundColor: Colors.black54,
          body: ListView(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 300,
                        height: 400,
                        margin: const EdgeInsets.only(left: 45),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("Baner-SanPacho.png"))),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 75),
                        child: const Text(
                          "Al Aire Rooftop",
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.white54,
                        width: 300,
                        height: 70,
                        margin: const EdgeInsets.only(left: 50, top: 25),
                        child: const Text(
                          "Los Mejores Platos Gastronomicos de la Region Con una Excelente Vista a la Hermosa Ciduad de Quibdó",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
