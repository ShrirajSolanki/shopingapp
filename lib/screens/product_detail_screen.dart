import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> _productDetailFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _productDetailFuture = _apiService.getProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          // Simplified cart icon for navigation
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: _productDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Product not found.'));
          } else {
            final product = snapshot.data!;
            return _buildDetailsBody(context, product, cartProvider);
          }
        },
      ),
    );
  }

  Widget _buildDetailsBody(BuildContext context, Product product, CartProvider cartProvider) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Size Product Image
                Center(
                  child: Image.network(
                    product.image,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  product.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    Text(' ${product.rating.rate} (${product.rating.count} Review)'),
                    const Spacer(),
                    Text(
                      'Seller: Syed Noman', // Placeholder seller name from image
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Price
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Tabs (Simplified)
                _buildDetailsTabs(product),
              ],
            ),
          ),
        ),
        // Bottom "Add to Cart" Button Area
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Quantity Control (simplified from the image)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(Icons.remove, size: 20), // Placeholder
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(Icons.add, size: 20), // Placeholder
              ),
              const SizedBox(width: 15),

              // Add to Cart Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    cartProvider.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.title} added to cart!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTabs(Product product) {
    // This replicates the look of the description tab from the image
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: const Color(0xFFFF9800),
            labelColor: const Color(0xFFFF9800),
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Description'),
              Tab(text: 'Specifications'),
              Tab(text: 'Reviews'),
              Tab(text: 'Shipping'),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200, // Fixed height for the content area
            child: TabBarView(
              children: [
                // Description Tab Content
                Text(product.description),
                // Placeholder content for other tabs
                const Center(child: Text('Specifications will go here.')),
                const Center(child: Text('Reviews will go here.')),
                const Center(child: Text('Shipping info will go here.')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}