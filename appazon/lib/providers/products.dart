import "dart:convert";

import "package:flutter/widgets.dart";
import "package:http/http.dart" as http;

class Products extends ChangeNotifier {
  final List<String> _categories = [];
  final Map<String, List<Map<String, dynamic>>> _products = {};

  double _size = 0;
  bool scrolled = false;

  get categories => _categories;

  Future<List<String>> loadCategories() async {
    if (_categories.isNotEmpty) return _categories;

    var response = await http
        .get(Uri.parse("https://ecommerce-dummy-data.onrender.com/categories"));

    List<String> data = List.from(jsonDecode(response.body)['categories']);

    _categories.addAll(data);

    return _categories;
  }

  Future<List<Map<String, dynamic>>> loadProducts(String category) async {
    if (_products[category] != null) return _products[category]!;
    var response = await http
        .get(Uri.parse("https://ecommerce-dummy-data.onrender.com/$category"));

    List<Map<String, dynamic>> data = List.from(jsonDecode(response.body));

    _products[category] = [];

    for (final product in data) {
      _products[category]!.add(product);
    }

    return data;
  }

  Future<List<Map<String, dynamic>>> getProducts(String category) async {
    if (_products.containsKey(category)) return _products[category]!;

    return await loadProducts(category);
  }

  void setSize(size) {
    _size = size;
  }

  void onScroll(offset, AnimationController? animationController) {
    if (offset > _size) {
      if (scrolled) return;
      scrolled = true;
    } else {
      if (!scrolled) return;
      scrolled = false;
    }

    if (animationController != null) {
      animationController.reset();
      animationController.forward();
    }
    notifyListeners();
  }
}
