import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.lightBlue,
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      var cartItem = cart.items.values.toList()[index];
                      return ListTile(
                        leading: Image.network(cartItem.product.image,
                            width: 50, height: 50),
                        title: Text(cartItem.product.title),
                        subtitle: Text(
                            '\$${cartItem.product.price} x ${cartItem.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (cartItem.quantity > 1) {
                                  cart.updateQuantity(cartItem.product.id,
                                      cartItem.quantity - 1);
                                }
                              },
                            ),
                            Text('${cartItem.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                cart.updateQuantity(
                                    cartItem.product.id, cartItem.quantity + 1);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cart.removeItem(cartItem.product.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CheckoutScreen()));
                  },
                  child: const Text('Proceed to Checkout'),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
