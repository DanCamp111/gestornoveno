import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/Utils/Ambiente.dart';
import 'package:proyecto/page/home.dart';

class Nuevacategoria extends StatefulWidget {
  const Nuevacategoria({super.key});

  @override
  State<Nuevacategoria> createState() => _NuevacategoriaState();
}

class _NuevacategoriaState extends State<Nuevacategoria> {
  TextEditingController txtNombre = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ver Categorias"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(40),
              child: TextFormField(
                controller: txtNombre,
                decoration: InputDecoration(label: Text('Usuario')),
              ),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('${Ambiente.urlServer}/api/categorias/save'),
                  body: jsonEncode(<String, dynamic>{
                    'nombre': txtNombre.text,
                    'id_usuario': Ambiente.id_usuario
                  }),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8'
                  },
                );

                print(response.body);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                ); // Cierre del Navigator.push
              },
              child: Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
