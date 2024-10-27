import 'package:alpha_reading/features/profile/editinfo/change_password.dart';
import 'package:alpha_reading/namednavigator/named-navigator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editinfo/editinfo.dart'; // Import EditProfile

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        userData = doc.data() as Map<String, dynamic>?;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Adjust route as needed
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent the app from closing
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: _logout,
            ),
          ],
        ),
        body: userData == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView( // Wrap the content in SingleChildScrollView
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: userData!['imageUrl'] != null
                              ? NetworkImage(userData!['imageUrl'])
                              : null,
                          child: userData!['imageUrl'] == null ? const Icon(Icons.person, size: 40) : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded( // Use Expanded to prevent overflow
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData!['fullName'] ?? 'User Name',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(user?.email ?? 'user@example.com'),
                              Text('Phone Number: ${userData!['phoneNumber'] ?? ''}'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.pushNamed(context, NamedNavigator.editProfile);
                            if (result == true) {
                              _fetchUserData(); // Refresh data after editing
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text('Account Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Change Password'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Saved Addresses'),
                      onTap: () {
                        // Navigate to saved addresses screen
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: const Text('balance'),
                      onTap: () {
                        // Navigate to saved cards screen
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Select Language'),
                      onTap: () {
                        // Navigate to select language screen
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.accessibility),
                      title: const Text('Accessibility Settings'),
                      onTap: () {
                        // Navigate to accessibility settings screen
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text('Notification Settings'),
                      onTap: () {
                        // Navigate to notification settings screen
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
