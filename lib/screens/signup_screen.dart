import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanity/reusable_widgets/reusable_widget.dart';
import 'package:humanity/screens/home_screen.dart';
import 'package:humanity/services/upload_image.dart';
import 'package:humanity/utils/color_utils.dart';
import 'package:humanity/services/select_image.dart';
import 'package:humanity/repository/firebase_api.dart';
import 'package:humanity/models/customer.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _surnameTextController = TextEditingController();
  final TextEditingController _idNumberTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _birthdayTextController = TextEditingController();
  File? imageToUpload;

  final FirebaseApi _firebaseApi = FirebaseApi();

  bool _isPasswordVisible = false;

  void _selectBirthdate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _birthdayTextController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  bool validateInputs() {
    if (_nameTextController.text.isEmpty ||
        _surnameTextController.text.isEmpty ||
        _idNumberTextController.text.isEmpty ||
        _emailTextController.text.isEmpty ||
        _passwordTextController.text.isEmpty ||
        _birthdayTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill out all fields")),
      );
      return false;
    }

    if (!_emailTextController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email")),
      );
      return false;
    }

    if (_passwordTextController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters long")),
      );
      return false;
    }

    return true;
  }

  void _showMessage(String msg) async {
    setState(() {
      SnackBar snackBar = SnackBar(content: Text(msg));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void _createCustomerDB(Customer customer) async {
    var result = await _firebaseApi.createCustomerDB(customer);
    print('create customer db');

    if (result == 'network-request-failed') {
      _showMessage('Revise su conexión a internet');
    } else {
      _showMessage('Usuario creado con éxito');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _registerCustomer(Customer customer) async{

    var result = await _firebaseApi.registerCustomer(customer.email, customer.password);

    if (result == 'invalid-email') {
      _showMessage('El correo electrónico está mal escrito');
    } else if (result == 'email-already-in-use') {
      _showMessage('Ya existe una cuenta con ese correo electrónico');
    } else if (result == 'weak-password') {
      _showMessage('La contraseña debe tener mínimo 6 dígitos');
    } else if (result == 'network-request-failed') {
      _showMessage('Revise su conexión a internet');
    } else {
      customer.uid = result!;
      print(customer.uid);
      _createCustomerDB(customer);
    }
  }

  void _onRegisterButtonClicked() async {

    String? imageUrl;
        if (imageToUpload != null) {
          // Upload image and retrieve URL
          final String uploadedImageUrl = await uploadImageAndGetUrl(imageToUpload!);
          if (uploadedImageUrl.isNotEmpty) {
            imageUrl = uploadedImageUrl;
            print(imageUrl);
          }
        }

    if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty) {
      _showMessage("ERROR: Debe digitar correo electrónico y contraseña");
    // } else if (_password.text != _repPassword.text) {
    //   _showMessage("ERROR: Las contraseñas deben de ser iguales");
    } else {
      var customer = Customer(
          "",
          _idNumberTextController.text,
          _nameTextController.text,
          _surnameTextController.text,
          _emailTextController.text,
          _passwordTextController.text,
          _birthdayTextController.text,
          imageUrl ?? '');
      _registerCustomer(customer);

      /* code */
    }
  }

  // Future<void> _registerUser() async {
  //   if (_validateInputs()) {
  //     try {
  //       UserCredential userCredential = await FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(
  //         email: _emailTextController.text,
  //         password: _passwordTextController.text,
  //       );

  //       String? imageUrl;
  //       if (imageToUpload != null) {
  //         // Upload image and retrieve URL
  //         final String uploadedImageUrl = await uploadImageAndGetUrl(imageToUpload!);
  //         if (uploadedImageUrl.isNotEmpty) {
  //           imageUrl = uploadedImageUrl;
  //         }
  //       }

  //       // FirebaseFirestore db = FirebaseFirestore.instance;

  //       // final user = <String, dynamic>{
  //       //   'name': _nameTextController.text,
  //       //   'surname': _surnameTextController.text,
  //       //   'idNumber': _idNumberTextController.text,
  //       //   'email': _emailTextController.text,
  //       //   'birthday': _birthdayTextController.text,
  //       //   'profilePicture': imageUrl ?? '',
  //       // };

  //       // db.collection("users").add(user).then((DocumentReference document) {
  //       //   print("DocumentSnapshot added with ID: ${document.id}");
  //       // });

  //       // Add user data to Firestore
  //       await FirebaseFirestore.instance
  //           .collection('customers')
  //           .doc(userCredential.user?.uid)
  //           .set({
  //         'name': _nameTextController.text,
  //         'surname': _surnameTextController.text,
  //         'idNumber': _idNumberTextController.text,
  //         'email': _emailTextController.text,
  //         'birthday': _birthdayTextController.text,
  //         'profilePicture': imageUrl ?? '',
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Registration successful")),
  //       );

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomeScreen()),
  //       );
  //     } catch (e) {
  //       print("Error: $e");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error: $e")),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Registrarse",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("00ff2e"),
              hexStringToColor("00ff8b"),
              hexStringToColor("03f7ff")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField(
                  "Ingrese Nombre(s)",
                  Icons.person_outline,
                  false,
                  _nameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Ingrese Apellido(s)",
                  Icons.person_outline,
                  false,
                  _surnameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Ingrese Documento de Identificación",
                  Icons.perm_identity,
                  false,
                  _idNumberTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Ingrese Email",
                  Icons.email_outlined,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordTextController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
                    labelText: "Ingrese Contraseña",
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _birthdayTextController,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today, color: Colors.black),
                    labelText: "Ingrese Cumpleaños",
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                  onTap: () => _selectBirthdate(context),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final image = await selectImage();
                    if (image != null) {
                      setState(() {
                        imageToUpload = File(image.path);
                      });
                    }
                  },
                  child: const Text("Select Image"),
                ),
                const SizedBox(height: 20),
                firebaseUIButton(context, "Registrarse", _onRegisterButtonClicked),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
