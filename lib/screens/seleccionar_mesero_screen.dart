import 'package:flutter/material.dart';
import '../models/mesa.dart';
import '../models/mesero.dart';
import '../services/api_service.dart';
import 'menu_screen.dart';

class SeleccionarMeseroScreen extends StatefulWidget {
  final Mesa mesa;

  const SeleccionarMeseroScreen({Key? key, required this.mesa})
      : super(key: key);

  @override
  State<SeleccionarMeseroScreen> createState() =>
      _SeleccionarMeseroScreenState();
}

class _SeleccionarMeseroScreenState extends State<SeleccionarMeseroScreen> {
  List<Mesero> meseros = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarMeseros();
  }

  Future<void> cargarMeseros() async {
    try {
      final meserosCargados = await ApiService.obtenerMeseros();
      setState(() {
        meseros = meserosCargados;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Mesero'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade100,
            child: Column(
              children: [
                const Icon(Icons.table_restaurant, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Mesa ${widget.mesa.numero}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.mesa.ubicacion ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
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
                                cargarMeseros();
                              },
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: meseros.length,
                        itemBuilder: (context, index) {
                          final mesero = meseros[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Text(
                                  mesero.nombre[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                mesero.nombreCompleto,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(mesero.telefono ?? 'Sin teléfono'),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.orange,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MenuScreen(
                                      mesa: widget.mesa,
                                      mesero: mesero,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}