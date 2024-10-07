import 'package:flutter/material.dart';

class BookInfo extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookInfo({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? 'Book Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book['image'] != null)
              Image.network(book['image']),
            const SizedBox(height: 16),
            Text(
              book['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              book['subtitle'] ?? 'No Subtitle',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              book['price'] ?? 'N/A',
              style: const TextStyle(fontSize: 18, color: Colors.redAccent),
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
