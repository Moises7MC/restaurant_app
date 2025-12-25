import 'package:flutter/foundation.dart';
import '../models/plato.dart';

class ItemCarrito {
  final Plato plato;
  int cantidad;
  String? observaciones;

  ItemCarrito({
    required this.plato,
    this.cantidad = 1,
    this.observaciones,
  });

  double get subtotal => plato.precio * cantidad;
}

class CarritoProvider extends ChangeNotifier {
  final List<ItemCarrito> _items = [];

  List<ItemCarrito> get items => _items;

  int get cantidadTotal => _items.fold(0, (sum, item) => sum + item.cantidad);

  double get total => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  void agregarPlato(Plato plato) {
    final index = _items.indexWhere((item) => item.plato.id == plato.id);
    
    if (index != -1) {
      _items[index].cantidad++;
    } else {
      _items.add(ItemCarrito(plato: plato));
    }
    
    notifyListeners();
  }

  void quitarPlato(int platoId) {
    final index = _items.indexWhere((item) => item.plato.id == platoId);
    
    if (index != -1) {
      if (_items[index].cantidad > 1) {
        _items[index].cantidad--;
      } else {
        _items.removeAt(index);
      }
    }
    
    notifyListeners();
  }

  void eliminarItem(int platoId) {
    _items.removeWhere((item) => item.plato.id == platoId);
    notifyListeners();
  }

  void actualizarObservaciones(int platoId, String observaciones) {
    final index = _items.indexWhere((item) => item.plato.id == platoId);
    if (index != -1) {
      _items[index].observaciones = observaciones;
      notifyListeners();
    }
  }

  void limpiarCarrito() {
    _items.clear();
    notifyListeners();
  }
}