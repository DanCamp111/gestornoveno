class Subcategorias {
  final int id;
  final String nombre;
  final Categoria categoria;  // Añade este campo

  Subcategorias(this.id, this.nombre, this.categoria);

  Subcategorias.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['nombre'],
        categoria = Categoria.fromJson(json['categoria']); // Mapea la categoría
}

class Categoria {
  final int id;
  final String nombre;

  Categoria(this.id, this.nombre);

  Categoria.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['nombre'];
}
