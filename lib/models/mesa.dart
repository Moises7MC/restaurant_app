class Mesa {
  final int id;
  final int numero;
  final int capacidad;
  final String estado;
  final String? ubicacion;

  Mesa({
    required this.id,
    required this.numero,
    required this.capacidad,
    required this.estado,
    this.ubicacion,
  });

  factory Mesa.fromJson(Map<String, dynamic> json) {
    return Mesa(
      id: json['id'],
      numero: json['numero'],
      capacidad: json['capacidad'],
      estado: json['estado'],
      ubicacion: json['ubicacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'capacidad': capacidad,
      'estado': estado,
      'ubicacion': ubicacion,
    };
  }
}