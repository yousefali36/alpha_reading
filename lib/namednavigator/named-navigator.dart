import 'package:flutter/material.dart';
import '../features/login/login.dart';
import '../features/signup/signup.dart';
import '../features/onboarding/onboarding.dart';
import '../main_screen.dart'; // Import MainScreen
import '../features/profile/profileview.dart';
import '../features/profile/editinfo/editinfo.dart'; // Import EditProfile
import '../features/profile/editinfo/change_password.dart'; // Import ChangePassword

class NamedNavigator {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main'; // Add main route
  static const String home = '/home'; // Define home route
  static const String profile = '/profile'; // Add profile route
  static const String editProfile = '/editProfile'; // Add edit profile route
  static const String changePassword = '/changePassword'; // Add change password route

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen()); // Use MainScreen
      case home:
        return MaterialPageRoute(builder: (_) => const MainScreen()); // Use MainScreen
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileView()); // Add ProfileView route
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfile()); // Add EditProfile route
      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen()); // Add ChangePassword route
      default:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
    }
  }
}