import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'cart_screen.dart';
import '../widgets/product_item.dart';
import 'dart:async';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        productProvider.fetchProducts();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      Provider.of<ProductProvider>(context, listen: false)
          .updateSearchQuery(query);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  bool _providerHasMore(ProductProvider provider) {
    return provider.hasMore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Products'),
          backgroundColor: Colors.lightBlue,
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartScreen()));
              },
            )
          ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Search Products',
                hintText: 'Enter product name or category',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.products.isEmpty && provider.isFetching) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.products.isEmpty && !_providerHasMore(provider)) {
                  return const Center(child: Text('No products found.'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.hasMore
                      ? provider.products.length + 1
                      : provider.products.length,
                  itemBuilder: (context, index) {
                    if (index >= provider.products.length) {
                      if (provider.isFetching) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return const SizedBox();
                      }
                    }
                    Product product = provider.products[index];
                    return ProductItem(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
