// test/unit/providers/product_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/providers/product_provider.dart';

void main() {
  group('ProductProvider', () {
    late ProductProvider productProvider;

    setUp(() {
      productProvider = ProductProvider();
    });

    test('Initial values are correct', () {
      expect(productProvider.products, []);
      expect(productProvider.isFetching, false);
      expect(productProvider.hasMore, true);
    });

    test('Update search query filters products correctly', () {
      // Assuming _allProducts is already populated
      productProvider.updateSearchQuery('shirt');
      // Verify that _filteredProducts contains only products with 'shirt' in title or category
      for (var product in productProvider.products) {
        expect(
          product.title.toLowerCase().contains('shirt') ||
              product.category.toLowerCase().contains('shirt'),
          true,
        );
      }
    });
  });
}
