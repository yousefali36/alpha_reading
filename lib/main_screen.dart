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

  void _saveBook(Book book) {
    if (!savedBooks.any((b) => b.isbn13 == book.isbn13)) {
      setState(() {
        savedBooks.add(book);
      });
    }
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
            HomeView(savedBooks: savedBooks, onSaveBook: _saveBook),
            SavedBooks(
              savedBooks: savedBooks.map((book) => book.toMap()).toList(),
            ),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
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