import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Getter for the total price of this item (quantity * product price)
  double get totalItemPrice => product.price * quantity;
}