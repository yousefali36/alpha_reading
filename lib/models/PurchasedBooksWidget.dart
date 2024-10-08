import 'package:alpha_reading/models/book.dart';
import 'package:flutter/material.dart';

class PurchasedBooksWidget extends StatelessWidget {
  final List<Book> purchasedBooks;
  final Function onPurchase;
  final Function onRemoveFromCart;

  PurchasedBooksWidget({
    required this.purchasedBooks,
    required this.onPurchase,
    required this.onRemoveFromCart,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: purchasedBooks.length,
      itemBuilder: (context, index) {
        final book = purchasedBooks[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => onPurchase(book),
          ),
        );
      },
    );
  }
}
