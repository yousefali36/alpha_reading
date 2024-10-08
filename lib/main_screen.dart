import 'package:alpha_reading/features/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io'; // Import for exit function
import 'features/home/homeview.dart';
import 'features/profile/profileview.dart';
import 'features/home/saved/saved.dart'; // Import for SavedBooks screen
import 'models/book.dart'; // Corrected path

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Book> savedBooks = [];
  final List<Map<String, dynamic>> cartItems = [];

  void _saveBook(Book book) {
    if (!savedBooks.any((b) => b.isbn13 == book.isbn13)) {
      setState(() {
        savedBooks.add(book);
      });
    }
  }

  void _removeFromCart(String isbn13) {
    setState(() {
      cartItems.removeWhere((item) => item['isbn13'] == isbn13);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0); // Close the app
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeView(
              savedBooks: savedBooks,
              onSaveBook: _saveBook,
              cartItems: cartItems,
              onRemoveFromCart: _removeFromCart, // Pass the callback
            ),
            SavedBooks(
              savedBooks: savedBooks.map((book) => book.toMap()).toList(),
            ),
            CartScreen(
              cartItems: cartItems,
              onRemoveFromCart: _removeFromCart, // Pass the callback
            ),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
            //BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}