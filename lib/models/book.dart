class Book {
    final String title;
    final String author;
    final String? subtitle;  // Assuming subtitle can be null
    final String? imageUrl;  // Assuming imageUrl can be null
    final String isbn13; // Unique identifier for the book

    Book({required this.title, required this.author, this.subtitle, this.imageUrl, required this.isbn13});

    factory Book.fromMap(Map<String, dynamic> map) {
        return Book(
            title: map['title'] ?? 'Unknown Title',
            author: map['author'] ?? 'Unknown Author',
            subtitle: map['subtitle'],
            imageUrl: map['image'],
            isbn13: map['isbn13'] // Ensure this key exists in your data
        );
    }

    Map<String, dynamic> toMap() {
        return {
            'title': title,
            'author': author,
            'subtitle': subtitle,
            'image': imageUrl,
            'isbn13': isbn13
        };
    }
}
