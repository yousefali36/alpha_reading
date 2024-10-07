import 'package:flutter/material.dart';

class BookSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> books;
  final Function(String) onSearch;

  BookSearchDelegate(this.books, this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(books[index]['title']),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onSearch(query);
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(books[index]['title']),
        );
      },
    );
  }
}
