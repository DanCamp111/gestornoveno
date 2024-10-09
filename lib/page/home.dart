import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyecto/Models/Categorias.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/Utils/Ambiente.dart';
import 'package:proyecto/page/NuevaCategoria.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Categorias> categorias = [];

  void fnObtenerCategorias() async {
    final response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/categorias'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        });
    print(response.body);

    Iterable mapCategorias = jsonDecode(response.body);
    categorias = List<Categorias>.from(
        mapCategorias.map((model) => Categorias.fromJson(model)));
    setState(() {});
  }

  Widget _ListviewCategorias() {
    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(categorias[index].id.toString()),
          subtitle: Text(categorias[index].nombre),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fnObtenerCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
      ),
      body: _ListviewCategorias(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Nuevacategoria())
        );
      },child: Icon(Icons.add),),
    );
  }
}
