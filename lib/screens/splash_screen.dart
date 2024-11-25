import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:humanity/screens/signin_screen.dart';
import 'package:humanity/screens/home_screen.dart';
import 'package:humanity/utils/color_utils.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _initializeFirebaseAndCheckAuth();
  }

  Future<void> _initializeFirebaseAndCheckAuth() async {
    try {
      // Add a delay to ensure the splash screen is shown for at least 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      // Initialize Firebase
      await Firebase.initializeApp();

      // Check if there's a currently logged-in user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the widget is still mounted before using the context
      if (!mounted) return;

      // Navigate based on authentication state
      if (user != null) {
        // User is logged in, navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // User is not logged in, navigate to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    } catch (e) {
      // Check if the widget is still mounted before using the context
      if (!mounted) return;

      // Show an error message if there's a problem initializing Firebase
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong! Please try again later.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("00ff2e"),
                hexStringToColor("00ff8b"),
                hexStringToColor("03f7ff")],
              begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the app's logo
            Image.asset(
              'assets/images/Logo_inv.png',
              height: 350, // Adjust the size as needed
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
