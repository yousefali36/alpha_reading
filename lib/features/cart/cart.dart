import 'package:flutter/material.dart';
import 'package:alpha_reading/namednavigator/named-navigator.dart'; // Import NamedNavigator

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(String) onRemoveFromCart;

  const CartScreen({Key? key, required this.cartItems, required this.onRemoveFromCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(0.0, (sum, item) {
      final price = item['price'];
      double itemPrice = 0.0;
      if (price is num) {
        itemPrice = price.toDouble();
      } else if (price is String) {
        itemPrice = double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      }
      return sum + itemPrice;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: item['image'] != null ? Image.network(item['image']) : null,
                  title: Text(item['title']),
                  subtitle: Text('Price: ${item['price']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      onRemoveFromCart(item['isbn13']);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Total: \$${totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, NamedNavigator.creditCard);
                  },
                  child: const Text('Check-Out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
