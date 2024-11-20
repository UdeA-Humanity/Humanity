import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:humanity/screens/signin_screen.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    // Get the current user from FirebaseAuth
    setState(() {
      _currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // Check if the widget is still mounted before using the context
    if (!mounted) return;
    // Navigate to LoginScreen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'User Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 20),
            if (_currentUser != null) ...[
              Text(
                'Email: ${_currentUser!.email}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
