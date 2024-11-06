class Categorias {
  final int id;
  final String nombre;
  List<Subcategoria> subcategorias; // Lista de subcategorías

  Categorias(this.id, this.nombre, this.subcategorias);

  Categorias.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['nombre'],
        subcategorias = (json['subcategorias'] as List)
            .map((item) => Subcategoria.fromJson(item))
            .toList(); // Mapeo de las subcategorías
}

class Subcategoria {
  final int id;
  final String nombre;

  Subcategoria(this.id, this.nombre);

  Subcategoria.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['nombre'];
}

