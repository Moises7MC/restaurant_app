class Plato {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final bool disponible;
  final int tiempoPreparacion;
  final Categoria categoria;

  Plato({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.disponible,
    required this.tiempoPreparacion,
    required this.categoria,
  });

  factory Plato.fromJson(Map<String, dynamic> json) {
    return Plato(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: (json['precio'] as num).toDouble(),
      disponible: json['disponible'],
      tiempoPreparacion: json['tiempoPreparacion'] ?? 0,
      categoria: Categoria.fromJson(json['categoria']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'disponible': disponible,
      'tiempoPreparacion': tiempoPreparacion,
    };
  }
}

class Categoria {
  final int id;
  final String nombre;
  final String descripcion;

  Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? '',
    );
  }
}