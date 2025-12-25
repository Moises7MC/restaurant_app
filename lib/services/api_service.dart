import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/plato.dart';
import '../models/mesa.dart';
import '../models/mesero.dart';
import '../models/pedido.dart';

class ApiService {
  // Obtener todos los platos disponibles
  static Future<List<Plato>> obtenerPlatos() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.platos}/disponibles'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Plato.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar platos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener todas las mesas
  static Future<List<Mesa>> obtenerMesas() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.mesas),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Mesa.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar mesas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener meseros activos
  static Future<List<Mesero>> obtenerMeseros() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.meseros}/activos'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Mesero.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar meseros: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear un nuevo pedido
  static Future<bool> crearPedido(Pedido pedido) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.pedidos),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pedido.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error al crear pedido: $e');
    }
  }
}