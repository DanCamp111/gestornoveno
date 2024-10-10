import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/Models/Categorias.dart';
import 'package:proyecto/Utils/Ambiente.dart';
import 'package:proyecto/page/home.dart';

class Nuevacategoria extends StatefulWidget {
  final Categorias? categoria; // Recibir la categoría si es para editar

  const Nuevacategoria({super.key, this.categoria});

  @override
  State<Nuevacategoria> createState() => _NuevacategoriaState();
}

class _NuevacategoriaState extends State<Nuevacategoria> {
  TextEditingController txtNombre = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      // Si es para editar, llenar el campo con el valor actual
      txtNombre.text = widget.categoria!.nombre;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.categoria == null ? "Nueva Categoría" : "Editar Categoría"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(40),
              child: TextFormField(
                controller: txtNombre,
                decoration:
                    InputDecoration(label: Text('Nombre de la Categoría')),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (widget.categoria == null) {
                  // Nueva categoría
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
                } else {
                  // Actualizar categoría existente
                  final response = await http.post(
                    Uri.parse(
                        '${Ambiente.urlServer}/api/categorias/${widget.categoria!.id}/update'),
                    body: jsonEncode(<String, dynamic>{
                      'nombre': txtNombre.text,
                      'id_usuario': Ambiente.id_usuario
                    }),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8'
                    },
                  );
                  print(response.body);
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              child: Text(widget.categoria == null ? "Guardar" : "Actualizar"),
            ),
          ],
        ),
      ),
    );
  }
}
