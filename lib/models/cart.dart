// lib/models/cart.dart
// Model keranjang belanja dengan logika analisis statistik (Sub CPMK-1)

import 'product.dart';

class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;

  // -----------------------------------------------
  // LOGIKA KERANJANG
  // -----------------------------------------------

  void addItem(Product product) {
    final existing = _items.indexWhere((i) => i.product.id == product.id);
    if (existing >= 0) {
      _items[existing].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
  }

  void incrementQuantity(String productId) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) _items[idx].quantity++;
  }

  void decrementQuantity(String productId) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      if (_items[idx].quantity > 1) {
        _items[idx].quantity--;
      } else {
        _items.removeAt(idx);
      }
    }
  }

  void clear() => _items.clear();

  // -----------------------------------------------
  // LOGIKA ANALISIS STATISTIK BELANJA (Sub CPMK-1)
  // -----------------------------------------------

  // Total biaya belanja
  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.subtotal);

  // Rata-rata harga barang di keranjang
  double get averagePrice {
    if (_items.isEmpty) return 0;
    return totalPrice / _items.length;
  }

  // Barang dengan harga tertinggi
  CartItem? get mostExpensiveItem {
    if (_items.isEmpty) return null;
    return _items.reduce((a, b) => a.product.price > b.product.price ? a : b);
  }

  // Barang dengan harga terendah
  CartItem? get cheapestItem {
    if (_items.isEmpty) return null;
    return _items.reduce((a, b) => a.product.price < b.product.price ? a : b);
  }

  // Total pax yang dipesan
  int get totalPax => _items.fold(0, (sum, item) => sum + (item.quantity * 20));

  // Persentase item temahal terhadap total
  double get mostExpensivePercentage {
    if (totalPrice == 0) return 0;
    return ((mostExpensiveItem?.subtotal ?? 0) / totalPrice) * 100;
  }
}
