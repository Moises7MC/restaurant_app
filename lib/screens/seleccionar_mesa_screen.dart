import 'package:flutter/material.dart';
import '../models/mesa.dart';
import '../services/api_service.dart';
import 'seleccionar_mesero_screen.dart';

class SeleccionarMesaScreen extends StatefulWidget {
  const SeleccionarMesaScreen({Key? key}) : super(key: key);

  @override
  State<SeleccionarMesaScreen> createState() => _SeleccionarMesaScreenState();
}

class _SeleccionarMesaScreenState extends State<SeleccionarMesaScreen> {
  List<Mesa> mesas = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarMesas();
  }

  Future<void> cargarMesas() async {
    try {
      final mesasCargadas = await ApiService.obtenerMesas();
      setState(() {
        mesas = mesasCargadas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Color getColorEstado(String estado) {
    switch (estado) {
      case 'libre':
        return Colors.green;
      case 'ocupada':
        return Colors.red;
      case 'reservada':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Mesa'),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
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
                          cargarMesas();
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: mesas.length,
                  itemBuilder: (context, index) {
                    final mesa = mesas[index];
                    final estaLibre = mesa.estado == 'libre';

                    return Card(
                      elevation: 4,
                      child: InkWell(
                        onTap: estaLibre
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SeleccionarMeseroScreen(mesa: mesa),
                                  ),
                                );
                              }
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: getColorEstado(mesa.estado),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.table_restaurant,
                                size: 50,
                                color: estaLibre ? Colors.orange : Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Mesa ${mesa.numero}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mesa.ubicacion ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getColorEstado(mesa.estado),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  mesa.estado,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}