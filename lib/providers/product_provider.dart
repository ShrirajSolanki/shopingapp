// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/product.dart';

// class ProductProvider extends ChangeNotifier {
//   final ApiService _api = ApiService();
//   List<String> categories = [];
//   Map<String, List<Product>> productsByCategory = {};
//   bool loading = false;

//   Future<void> loadCategories() async {
//     loading = true;
//     notifyListeners();
//     try {
//       categories = await _api.fetchCategories();
//     } catch (e) {
//       categories = [];
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> loadProducts(String category) async {
//     loading = true;
//     notifyListeners();
//     try {
//       final prods = await _api.fetchProductsByCategory(category);
//       productsByCategory[category] = prods;
//     } catch (e) {
//       productsByCategory[category] = [];
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<Product> getProductDetail(int id) => _api.fetchProductById(id);
// }
