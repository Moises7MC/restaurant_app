class DetallePedido {
  final int platoId;
  final int cantidad;
  final String? observaciones;

  DetallePedido({
    required this.platoId,
    required this.cantidad,
    this.observaciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'plato': {'id': platoId},
      'cantidad': cantidad,
      'observaciones': observaciones,
    };
  }
}

class Pedido {
  final int? id;
  final int mesaId;
  final int meseroId;
  final String? observaciones;
  final List<DetallePedido> detalles;

  Pedido({
    this.id,
    required this.mesaId,
    required this.meseroId,
    this.observaciones,
    required this.detalles,
  });

  Map<String, dynamic> toJson() {
    return {
      'mesa': {'id': mesaId},
      'mesero': {'id': meseroId},
      'observaciones': observaciones,
      'detalles': detalles.map((d) => d.toJson()).toList(),
    };
  }
}