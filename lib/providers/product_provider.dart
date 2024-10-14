import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';
import 'package:hive/hive.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isFetching = false;
  bool _hasMore = true;
  String _searchQuery = '';

  List<Product> get products => _filteredProducts;
  bool get isFetching => _isFetching;
  bool get hasMore => _hasMore;

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (_isFetching || !_hasMore) return;

    _isFetching = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Product> fetchedProducts =
            data.map((item) => Product.fromJson(item)).toList();
        _allProducts.addAll(fetchedProducts);
        applyFilter();

        var box = Hive.box<Product>('productsBox');
        await box.clear();
        await box.addAll(_allProducts);

        _hasMore = false;
      } else {
        print('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      var box = Hive.box<Product>('productsBox');
      List<Product> cachedProducts = box.values.toList();
      if (cachedProducts.isNotEmpty) {
        _allProducts = cachedProducts;
        applyFilter();
      } else {
        print('No cached products available.');
      }
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Product findById(int id) {
    return _allProducts.firstWhere((prod) => prod.id == id);
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    applyFilter();
    notifyListeners();
  }

  void applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts = _allProducts.where((product) {
        return product.title.toLowerCase().contains(_searchQuery) ||
            product.category.toLowerCase().contains(_searchQuery);
      }).toList();
    }
  }
}
