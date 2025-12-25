import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mesa.dart';
import '../models/mesero.dart';
import '../models/pedido.dart';
import '../providers/carrito_provider.dart';
import '../services/api_service.dart';

class VerCarritoScreen extends StatelessWidget {
  final Mesa? mesa;
  final Mesero? mesero;

  const VerCarritoScreen({Key? key, this.mesa, this.mesero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        backgroundColor: Colors.orange,
      ),
      body: carrito.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'El carrito está vacío',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                if (mesa != null && mesero != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.orange.shade100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.table_restaurant),
                            Text(
                              'Mesa ${mesa!.numero}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.person),
                            Text(
                              mesero!.nombreCompleto,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: carrito.items.length,
                    itemBuilder: (context, index) {
                      final item = carrito.items[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.plato.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      carrito.eliminarItem(item.plato.id);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle,
                                            color: Colors.orange),
                                        onPressed: () {
                                          carrito.quitarPlato(item.plato.id);
                                        },
                                      ),
                                      Text(
                                        '${item.cantidad}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle,
                                            color: Colors.orange),
                                        onPressed: () {
                                          carrito.agregarPlato(item.plato);
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'S/ ${item.subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  _mostrarDialogoObservaciones(
                                      context, carrito, item);
                                },
                                child: Text(
                                  item.observaciones == null ||
                                          item.observaciones!.isEmpty
                                      ? '+ Agregar observaciones'
                                      : 'Obs: ${item.observaciones}',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'S/ ${carrito.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (mesa != null && mesero != null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await _enviarPedido(context, carrito);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Enviar Pedido a Cocina',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _mostrarDialogoObservaciones(
      BuildContext context, CarritoProvider carrito, item) {
    final controller = TextEditingController(text: item.observaciones ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Observaciones para ${item.plato.nombre}'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Ej: Sin cebolla, término medio, etc.',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              carrito.actualizarObservaciones(
                item.plato.id,
                controller.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _enviarPedido(
      BuildContext context, CarritoProvider carrito) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final detalles = carrito.items
          .map((item) => DetallePedido(
                platoId: item.plato.id,
                cantidad: item.cantidad,
                observaciones: item.observaciones,
              ))
          .toList();

      final pedido = Pedido(
        mesaId: mesa!.id,
        meseroId: mesero!.id,
        detalles: detalles,
      );

      final success = await ApiService.crearPedido(pedido);

      Navigator.pop(context); // Cerrar loading

      if (success) {
        carrito.limpiarCarrito();
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¡Éxito!'),
            content: const Text('El pedido se envió correctamente a cocina'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      } else {
        _mostrarError(context, 'No se pudo crear el pedido');
      }
    } catch (e) {
      Navigator.pop(context); // Cerrar loading
      _mostrarError(context, e.toString());
    }
  }

  void _mostrarError(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(mensaje),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
