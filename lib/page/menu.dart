import 'package:flutter/material.dart';
import 'package:proyecto/Models/Subcategorias.dart';
import 'home.dart'; // Asegúrate de que la ruta sea correcta
import 'subcategoria.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Text('Categorías'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () 
              {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeSubcategorias()),
                );
              },
              child: Text('Subcategorías'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Menu(),
  ));
}