import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  var item = cart.items.values.toList()[index];
                  return ListTile(
                    title: Text(item.product.title),
                    subtitle:
                        Text('\$${item.product.price} x ${item.quantity}'),
                  );
                },
              ),
            ),
            Text('Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                cart.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order Confirmed')));
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Confirm Order'),
            )
          ],
        ),
      ),
    );
  }
}
