import 'package:alpha_reading/models/book.dart';
import 'package:alpha_reading/namednavigator/named-navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // Import for exit function
import '../profile/profileview.dart'; // Import ProfileView
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firebase Storage
import 'package:firebase_storage/firebase_storage.dart'; // Import for Firebase Storage
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book_info/book_info.dart'; // Import the BookInfo screen

class HomeView extends StatefulWidget {
  final List<Book> savedBooks; // Define savedBooks in the widget
  final Function(Book) onSaveBook; // Define onSaveBook in the widget
  final List<Map<String, dynamic>> cartItems; // Pass cartItems from MainScreen
  final Function(String) onRemoveFromCart; // Add a callback function

  HomeView({Key? key, required this.savedBooks, required this.onSaveBook, required this.cartItems, required this.onRemoveFromCart}) : super(key: key); // Add savedBooks, onSaveBook, and cartItems to the constructor

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> books = []; // Example book list
  Set<String> savedBookIds = Set(); // Track saved books by ID
  Set<String> cartBookIds = Set(); // Track cart books by ID
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    // Initialize savedBookIds from savedBooks
    savedBookIds = widget.savedBooks.map((book) => book.isbn13).toSet();
    // Initialize cartBookIds from cartItems
    cartBookIds = widget.cartItems.map((item) => item['isbn13'] as String).toSet();
  }

  Future<void> _fetchBooks() async {
    try {
      final response = await http.get(Uri.parse('https://api.itbook.store/1.0/new'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          books = data['books'].map<Map<String, dynamic>>((book) => book as Map<String, dynamic>).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load books: ${response.reasonPhrase}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  Future<String?> _getUserProfileImageUrl() async {
    // Implement your logic to get the user profile image URL
    return null;
  }

  void handleSaveBook(Map<String, dynamic> bookData) {
    Book book = Book.fromMap(bookData);
    if (!widget.savedBooks.any((b) => b.isbn13 == book.isbn13)) {
      widget.onSaveBook(book);
      setState(() {
        savedBookIds.add(book.isbn13); // Update local state to reflect the saved status
      });
    }
  }

  void _addToCart(Map<String, dynamic> book) {
    if (!cartBookIds.contains(book['isbn13'])) {
      setState(() {
        widget.cartItems.add(book);
        cartBookIds.add(book['isbn13']);
      });
    }
  }

  void _removeFromCart(String isbn13) {
    setState(() {
      widget.cartItems.removeWhere((item) => item['isbn13'] == isbn13);
      cartBookIds.remove(isbn13);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0); // Close the app
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Releases'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          actions: [
            FutureBuilder<String?>(
              future: _getUserProfileImageUrl(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data != null) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileView()),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileView()),
                      );
                    },
                    child: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  );
                }
              },
            ),
            const SizedBox(width: 16),
            /*IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, NamedNavigator.cart);
              },
            ),*/
            /*IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () async {
                await Navigator.pushNamed(context, NamedNavigator.cart);
                setState(() {
                  // Refresh the state to update the UI
                });
              },
            ),*/
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        final isSaved = savedBookIds.contains(book['isbn13']);
                        final isInCart = cartBookIds.contains(book['isbn13']);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookInfo(book: book),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                    child: book['image'] != null
                                        ? Image.network(
                                            book['image'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          )
                                        : const Placeholder(), // Provide a fallback if the image is null
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book['title'] ?? 'No Title', // Handle null title
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        book['subtitle'] ?? 'No Subtitle', // Handle null subtitle
                                        style: const TextStyle(color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        book['price'] ?? 'N/A', // Handle null price
                                        style: const TextStyle(color: Colors.redAccent),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () => handleSaveBook(book),
                                        child: Text(isSaved ? 'Saved' : 'Save'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => isInCart ? _removeFromCart(book['isbn13']) : _addToCart(book),
                                        child: Text(isInCart ? 'Added to Cart' : 'Add to Cart'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
        /* Uncomment if needed
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
        ),
        */
      ),
    );
  }
}