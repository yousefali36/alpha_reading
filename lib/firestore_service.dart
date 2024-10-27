import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveBook(String userId, Map<String, dynamic> bookData) async {
    await _db.collection('saved_books').add({
      ...bookData,
      'userId': userId,
    });
  }

  Future<void> addToCart(String userId, Map<String, dynamic> cartData) async {
    await _db.collection('carts').doc(userId).collection('items').doc(cartData['isbn13']).set(cartData);
  }

  Future<void> removeFromCart(String userId, String isbn13) async {
    await _db.collection('carts').doc(userId).collection('items').doc(isbn13).delete();
  }

  Future<List<Map<String, dynamic>>> fetchSavedBooks(String userId) async {
    final snapshot = await _db.collection('saved_books').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> fetchCartItems(String userId) async {
    final snapshot = await _db.collection('carts').doc(userId).collection('items').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> createUserInFirestore(String userId, String phoneNumber, String imageUrl) async {
    final userDoc = _db.collection('users').doc(userId);

    // Check if the user document exists
    DocumentSnapshot docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // If user doesn't exist, create the document with user info
      await userDoc.set({
        'phoneNumber': phoneNumber,
        'imageUrl': imageUrl,
      });

      // Create empty saved_books and cart subcollections
      await userDoc.collection('saved_books').doc('placeholder').set({});
      await userDoc.collection('cart').doc('placeholder').set({});

      // Optionally, delete the placeholders after
      await userDoc.collection('saved_books').doc('placeholder').delete();
      await userDoc.collection('cart').doc('placeholder').delete();
    }
  }
}
