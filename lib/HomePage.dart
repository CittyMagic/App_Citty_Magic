import 'package:cittyquibdo/Bottom_Nav.dart';
import 'package:cittyquibdo/Routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Navigator(
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                    builder: (context) => Routes(index: index),
                  );
                default:
                  return MaterialPageRoute(builder: (context) => Container());
              }
            },
          ),
        ),
        bottomNavigationBar: BNavigator(
          currentIndex: (i) {
            setState(
              () {
                index = i;
              },
            );
          },
        ),
      ),
    );
  }
}
