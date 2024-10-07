import 'package:flutter/material.dart';
import '../book_info/book_info.dart'; // Import the BookInfo screen

class SavedBooks extends StatelessWidget {
  final List<Map<String, dynamic>> savedBooks;

  const SavedBooks({Key? key, required this.savedBooks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Books')),
      body: savedBooks.isEmpty
          ? const Center(child: Text('No saved books'))
          : ListView.builder(
              itemCount: savedBooks.length,
              itemBuilder: (context, index) {
                final book = savedBooks[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookInfo(book: book),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: book['image'] != null ? Image.network(book['image']) : null,
                    title: Text(book['title'] ?? 'No Title'),
                    subtitle: Text(book['subtitle'] ?? 'No Subtitle'),
                  ),
                );
              },
            ),
    );
  }
}
