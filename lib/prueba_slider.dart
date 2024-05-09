import 'package:flutter/material.dart';
import 'package:cittyquibdo/componentes/slider.dart';

void main() {
  runApp(SliderPru());
}

class SliderPru extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Slider',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firebase Slider Example'),
        ),
        body: Center(
          child: SliderWidget(
            folderPath:
                '/fotos/App Img/2.Turismo/1.Chocó/2.Tadó/Descubre y Explora/Mumbú/Sliders Img/Cascada y Jacuzzi Natural',
          ),
        ),
      ),
    );
  }
}
