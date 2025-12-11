import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  // 1. Get all categories
  Future<List<String>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/products/categories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // 2. Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    final formattedCategory = category.replaceAll(' ', '%20');
    final response = await http.get(
      Uri.parse('$baseUrl/products/category/$formattedCategory'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products for category: $category');
    }
  }

  // 3. Get single product details
  Future<Product> getProductDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product details for ID: $id');
    }
  }

  // 4. Get all products (for the dashboard grid)
  Future<List<Product>> getAllProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products?limit=10'),
    ); // Limit to 10 for dashboard load
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load all products');
    }
  }
}
