import 'package:alpha_reading/features/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // Use SystemNavigator.pop
import 'features/home/homeview.dart';
import 'features/profile/profileview.dart';
import 'features/home/saved/saved.dart'; // Import for SavedBooks screen
import 'models/book.dart'; // Corrected path
import 'package:alpha_reading/firestore_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final List<Map<String, dynamic>> cartItems = [];
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<Book> savedBooks = []; // Define savedBooks

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch cart items
      final cartItemsData = await _firestoreService.fetchCartItems(userId);
      // Fetch saved books
      final savedBooksData = await _firestoreService.fetchSavedBooks(userId);
      setState(() {
        cartItems.addAll(cartItemsData);
        savedBooks = savedBooksData.map((data) => Book.fromMap(data, data['id'])).toList();
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _saveBook(Book book) async {
    if (!savedBooks.any((b) => b.isbn13 == book.isbn13)) {
      await _firestoreService.saveBook(userId, book.toMap());
      setState(() {
        savedBooks.add(book);
      });
    }
  }

  void _addToCart(Map<String, dynamic> book) async {
    if (!cartItems.any((item) => item['isbn13'] == book['isbn13'])) {
      await _firestoreService.addToCart(userId, book);
      setState(() {
        cartItems.add(book);
      });
    }
  }

  void _removeFromCart(String isbn13) async {
    await _firestoreService.removeFromCart(userId, isbn13);
    setState(() {
      cartItems.removeWhere((item) => item['isbn13'] == isbn13);
    });
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
        // Use SystemNavigator.pop() instead of exit(0)
        SystemNavigator.pop();
        return false; // Indicate that we handle the back press manually
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