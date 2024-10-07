import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this import
import 'firebase_options.dart'; // Add this import
import 'namednavigator/named-navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  try {
    await Firebase.initializeApp( // Initialize Firebase
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully'); // Add this line
  } catch (e) {
    print('Failed to initialize Firebase: $e'); // Add this line
  }
  runApp(const MyApp()); // Added const to MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: NamedNavigator.onboarding, // Set initial route to Onboarding
      onGenerateRoute: NamedNavigator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}