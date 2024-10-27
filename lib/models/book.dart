class Book {
    final String id; // Firestore document ID
    final String title;
    final String author;
    final String? subtitle;  // Assuming subtitle can be null
    final String? imageUrl;  // Assuming imageUrl can be null
    final String isbn13; // Unique identifier for the book

    Book({
        required this.id,
        required this.title,
        required this.author,
        this.subtitle,
        this.imageUrl,
        required this.isbn13,
    });

    factory Book.fromMap(Map<String, dynamic> data, String documentId) {
        return Book(
            id: documentId,
            title: data['title'] ?? 'No Title',
            author: data['author'] ?? 'Unknown Author',
            subtitle: data['subtitle'],
            imageUrl: data['image'],
            isbn13: data['isbn13'],
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
