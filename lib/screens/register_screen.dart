import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _surnameController,
                  decoration: const InputDecoration(labelText: "Surname"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your surname';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _birthdayController,
                  decoration: const InputDecoration(labelText: "Birthday (DD/MM/YYYY)"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your birthday';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _idNumberController,
                  decoration: const InputDecoration(labelText: "ID Number"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ID number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        child: const Text("Register"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        // Crear usuario en Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Obtener el UID del usuario
        String uid = userCredential.user!.uid;

        // Guardar datos adicionales en Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uID': uid,
          'Name': _nameController.text.trim(),
          'Surname': _surnameController.text.trim(),
          'Email': _emailController.text.trim(),
          'Password': _passwordController.text.trim(),
          'Birthday': _birthdayController.text.trim(),
          'ID_number': _idNumberController.text.trim(),
        });

        // Si el widget sigue montado, navegar de regreso al login
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful!")),
          );
        }
      } catch (e) {
        if (mounted) {
          // Mostrar un mensaje de error si el widget sigue montado
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to register. Please try again.")),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
