import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mesa.dart';
import '../models/mesero.dart';
import '../models/plato.dart';
import '../services/api_service.dart';
import '../providers/carrito_provider.dart';
import 'ver_carrito_screen.dart';

class MenuScreen extends StatefulWidget {
  final Mesa mesa;
  final Mesero mesero;

  const MenuScreen({Key? key, required this.mesa, required this.mesero})
      : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Plato> platos = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarPlatos();
  }

  Future<void> cargarPlatos() async {
    try {
      final platosCargados = await ApiService.obtenerPlatos();
      setState(() {
        platos = platosCargados;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú'),
        backgroundColor: Colors.orange,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerCarritoScreen(
                        mesa: widget.mesa,
                        mesero: widget.mesero,
                      ),
                    ),
                  );
                },
              ),
              if (carrito.cantidadTotal > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '${carrito.cantidadTotal}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
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
                      'Mesa ${widget.mesa.numero}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.person),
                    Text(
                      widget.mesero.nombreCompleto,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 60, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              'Error: $error',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                  error = null;
                                });
                                cargarPlatos();
                              },
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: platos.length,
                        itemBuilder: (context, index) {
                          final plato = platos[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange.shade100,
                                child: const Icon(Icons.restaurant,
                                    color: Colors.orange),
                              ),
                              title: Text(
                                plato.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(plato.descripcion),
                                  const SizedBox(height: 4),
                                  Text(
                                    'S/ ${plato.precio.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.add_circle,
                                    color: Colors.orange, size: 32),
                                onPressed: () {
                                  carrito.agregarPlato(plato);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('${plato.nombre} agregado'),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: carrito.cantidadTotal > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerCarritoScreen(
                      mesa: widget.mesa,
                      mesero: widget.mesero,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.orange,
              icon: const Icon(Icons.shopping_cart),
              label: Text('Ver Carrito (${carrito.cantidadTotal})'),
            )
          : null,
    );
  }
}