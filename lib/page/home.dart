import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:proyecto/Models/Categorias.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/Utils/Ambiente.dart';
import 'package:proyecto/page/NuevaCategoria.dart';
import 'menu.dart'; // Asegúrate de que la ruta sea correcta

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
      },
    );

    if (response.statusCode == 200) {
      print("Respuesta exitosa: ${response.body}"); // Imprime la respuesta

      Iterable mapCategorias = jsonDecode(response.body);
      categorias = List<Categorias>.from(
          mapCategorias.map((model) => Categorias.fromJson(model)));
      categorias.sort((a, b) => a.id.compareTo(b.id));

      setState(() {});
    } else {
      print(
          "Error en la respuesta: ${response.body}"); // Imprime el error si lo hay
    }
  }

  void fnEliminarCategoria(int id) async {
    final response = await http.delete(
      Uri.parse('${Ambiente.urlServer}/api/categorias/$id/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      categorias.removeWhere((categoria) => categoria.id == id);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Categoría eliminada con éxito')),
      );
    } else {
      print('Error al eliminar: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la categoría')),
      );
    }
  }

  Widget _ListviewCategorias() {
    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        // Verifica si la categoría tiene subcategorías
        var subcategorias = categorias[index].subcategorias;

        return ExpansionTile(
          title: Text(categorias[index].nombre),
          children: subcategorias.isNotEmpty
              ? subcategorias.map((subcategoria) {
                  return ListTile(
                    title: Text(subcategoria.nombre),
                    onTap: () {
                      // Opcional: acción al seleccionar una subcategoría
                    },
                  );
                }).toList()
              : [
                  // Si no tiene subcategorías, muestra el texto "Sin Subcategorías"
                  ListTile(
                    title: Text("Sin Subcategorías"),
                  ),
                ],
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Nuevacategoria(categoria: categorias[index]),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _confirmarEliminacion(categorias[index].id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmarEliminacion(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta categoría?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                fnEliminarCategoria(id);
              },
              child: Text('Eliminar'),
            ),
          ],
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
        title: Text("Categorías"),
      ),
      drawer: CustomDrawer(), // Aquí importas el Drawer
      body: _ListviewCategorias(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Nuevacategoria()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
