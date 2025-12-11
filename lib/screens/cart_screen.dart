import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_product_card.dart';
import '../widgets/app_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return Column(
            children: [
              // List of Cart Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return CartProductCard(item: item);
                  },
                ),
              ),

              // Checkout Summary Area
              _buildCheckoutSummary(context, cartProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckoutSummary(BuildContext context, CartProvider cartProvider) {
    final subtotal = cartProvider.subtotal;
    const discount = 0.00; // Placeholder for discount
    final total = subtotal - discount;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Discount Code Field (from image)
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Discount Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Functionality: Apply Coupon (placeholder)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  minimumSize: const Size(80, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Price Breakdown
          _buildPriceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}', Colors.black),
          _buildPriceRow('Discount', '-\$${discount.toStringAsFixed(2)}', Colors.red),
          const Divider(),
          _buildPriceRow('Total', '\$${total.toStringAsFixed(2)}', Colors.black, isTotal: true),
          const SizedBox(height: 20),

          // Checkout Button (non-functional placeholder)
          AppButton(
            text: 'Checkout',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Checkout functionality is a placeholder.')),
              );
            },
            backgroundColor: const Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, Color color, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}