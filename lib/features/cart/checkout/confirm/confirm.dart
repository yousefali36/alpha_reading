import 'package:alpha_reading/namednavigator/named-navigator.dart';
import 'package:flutter/material.dart';

class ConfirmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              'Your order has been placed successfully!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  NamedNavigator.home,
                  (route) => false,
                ); // Navigate to home screen and remove all previous routes
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
