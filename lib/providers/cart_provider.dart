import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import 'package:hive/hive.dart';

class CartProvider with ChangeNotifier {
  Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  CartProvider() {
    loadCart();
  }

  void loadCart() async {
    var box = Hive.box<CartItem>('cartBox');
    for (var cartItem in box.values) {
      _items[cartItem.product.id] = cartItem;
    }
    notifyListeners();
  }

  void addItem(Product product) async {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product, quantity: 1),
      );
    }

    // Update Hive
    var box = Hive.box<CartItem>('cartBox');
    await box.put(product.id, _items[product.id]!);

    notifyListeners();
  }

  void removeItem(int productId) async {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      var box = Hive.box<CartItem>('cartBox');
      await box.delete(productId);
      notifyListeners();
    }
  }

  void updateQuantity(int productId, int quantity) async {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: quantity,
        ),
      );

      var box = Hive.box<CartItem>('cartBox');
      await box.put(productId, _items[productId]!);

      notifyListeners();
    }
  }

  void clear() async {
    _items = {};
    var box = Hive.box<CartItem>('cartBox');
    await box.clear();
    notifyListeners();
  }
}
