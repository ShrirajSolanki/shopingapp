import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  // Functionality: Add product to cart
  void addToCart(Product product) {
    // Check if the product is already in the cart
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // If it exists, increment quantity
      _items[existingItemIndex].quantity++;
    } else {
      // If it's new, add a new CartItem
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  // Functionality: Increment quantity
  void incrementQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  // Functionality: Decrement quantity
  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      // Optional: remove item if quantity drops to 0. 
      // Based on UI, we'll let the remove button handle deletion for simplicity.
    }
    notifyListeners();
  }

  // Functionality: Remove item from cart
  void removeItem(CartItem item) {
    _items.removeWhere((i) => i.product.id == item.product.id);
    notifyListeners();
  }

  // Functionality: Calculate total bill
  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalItemPrice);
  }

  // Helper function to get cart item count
  int get itemCount {
    return _items.length;
  }
}