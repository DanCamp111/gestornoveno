import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/Models/Categorias.dart';
import 'package:proyecto/Models/Subcategorias.dart';
import 'package:proyecto/Utils/Ambiente.dart';
import 'package:proyecto/page/home.dart';
import 'package:proyecto/page/menu.dart';
import 'package:proyecto/page/subcategoria.dart';

class NuevaSubcategoria extends StatefulWidget {
  final Subcategorias? subcategoria; // Subcategoría a editar (opcional)

  NuevaSubcategoria({this.subcategoria}); // Constructor que acepta subcategoría

  @override
  State<NuevaSubcategoria> createState() => _NuevaSubcategoriaState();
}

class _NuevaSubcategoriaState extends State<NuevaSubcategoria> {
  TextEditingController txtNombre = TextEditingController();
  List<Categorias> categorias = [];
  Categorias? categoriaSeleccionada; // La categoría seleccionada

  @override
  void initState() {
    super.initState();
    fnObtenerCategorias();
  }

  // Función para obtener las categorías del servidor
  void fnObtenerCategorias() async {
    final response = await http.get(
      Uri.parse('${Ambiente.urlServer}/api/categorias'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      Iterable mapCategorias = jsonDecode(response.body);
      setState(() {
        categorias = List<Categorias>.from(
          mapCategorias.map((model) => Categorias.fromJson(model)),
        );
      });

      // Si estamos editando una subcategoría, establecer la categoría actual
      if (widget.subcategoria != null) {
        txtNombre.text = widget.subcategoria!.nombre;

        setState(() {
          categoriaSeleccionada = categorias.firstWhere(
            (categoria) => categoria.id == widget.subcategoria!.categoria.id,// En caso de que la categoría no exista
          );
        });
      }
    } else {
      print('Error al cargar categorías');
    }
  }

  // Función para guardar o actualizar una subcategoría
  Future<void> fnGuardarSubcategoria() async {
    if (categoriaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona una categoría')),
      );
      return;
    }

    // Si estamos editando, usamos el método PUT, si no, usamos POST
    String url = widget.subcategoria != null
        ? '${Ambiente.urlServer}/api/subcategorias/${widget.subcategoria!.id}/update'
        : '${Ambiente.urlServer}/api/subcategorias/save';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(<String, dynamic>{
        'nombre': txtNombre.text,
        'categoria_id': categoriaSeleccionada!.id, // ID de la categoría seleccionada
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeSubcategorias()),
      );
    } else {
      print('Error al guardar subcategoría: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subcategoria == null ? "Nueva Subcategoría" : "Editar Subcategoría"),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(40),
              child: TextFormField(
                controller: txtNombre,
                decoration: InputDecoration(label: Text('Nombre de la Subcategoría')),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(40),
              child: DropdownButton<Categorias>(
                hint: Text('Selecciona una Categoría'),
                value: categoriaSeleccionada,
                isExpanded: true,
                items: categorias.map((Categorias categoria) {
                  return DropdownMenuItem<Categorias>(
                    value: categoria,
                    child: Text(categoria.nombre),
                  );
                }).toList(),
                onChanged: (Categorias? newValue) {
                  setState(() {
                    categoriaSeleccionada = newValue;
                  });
                },
              ),
            ),
            TextButton(
              onPressed: fnGuardarSubcategoria,
              child: Text(widget.subcategoria == null ? "Guardar Subcategoría" : "Actualizar Subcategoría"),
            ),
          ],
        ),
      ),
    );
  }
}
