import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:humanity/screens/signin_screen.dart';
import 'package:humanity/services/select_image.dart';
import 'package:humanity/services/upload_image.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;

  File? image_to_upload;

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
        title: const Text("Profile"),
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

            if (image_to_upload != null) 
              Image.file(
              image_to_upload!,
              height: 300,
              width: 400,
              fit: BoxFit.cover,
              )
            else 
              Container(
                margin: const EdgeInsets.all(10),
                height: 300,
                width: 400,
                color: Colors.grey,
                child: const Center(child: Text("No image selected")),
              ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: () async{

              final imagen = await selectImage();

              setState(() {
                image_to_upload = File(imagen!.path);
              });
            }, child: const Text("Select image")),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: () async{

              if (image_to_upload == null) {
                return;
              }

              final uploaded = await uploadImage(image_to_upload!);

              if (uploaded){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Imagen subida correctamente")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al subir la imagen")));
              }

            }, child: const Text("Upload profile picture")),

            const SizedBox(height: 20),

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
