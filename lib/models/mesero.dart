class Mesero {
  final int id;
  final String nombre;
  final String apellido;
  final String? telefono;
  final bool activo;

  Mesero({
    required this.id,
    required this.nombre,
    required this.apellido,
    this.telefono,
    required this.activo,
  });

  factory Mesero.fromJson(Map<String, dynamic> json) {
    return Mesero(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
      activo: json['activo'],
    );
  }

  String get nombreCompleto => '$nombre $apellido';
}