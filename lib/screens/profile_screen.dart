// profile_screen.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/customer.dart';
import 'signin_screen.dart';
import 'package:humanity/profile_related_screens/my_service_screen.dart';
import 'package:humanity/profile_related_screens/notifications_screen.dart';
import 'package:humanity/profile_related_screens/payment_methods_screen.dart';
import 'package:humanity/profile_related_screens/privacy_policy_screen.dart';
import 'package:humanity/profile_related_screens/provider_info_screen.dart';
import 'package:humanity/profile_related_screens/view_profile_screen.dart';
import 'package:humanity/utils/color_utils.dart';
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
  bool showService = false;
  Customer? customerData;  // Variable para almacenar los datos del usuario

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadCustomerData();  // Añadimos esta función
  }

  void _loadUser() {
    setState(() {
      _currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> _loadCustomerData() async {
    if (_currentUser != null) {
      try {
        // Obtener datos del usuario desde Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('customers')
            .doc(_currentUser!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            // Crear instancia de Customer con los datos de Firestore
            customerData = Customer.fromJson(userDoc.data()!);
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> _updateProfilePic() async {
    if (image_to_upload != null && customerData != null) {
      try {
        final uploaded = await uploadImage(image_to_upload!);

        if (uploaded) {
          // Actualizar la URL de la imagen en el modelo Customer
          customerData!.profilePic = image_to_upload!.path;

          // Actualizar en Firestore
          await FirebaseFirestore.instance
              .collection('customers')
              .doc(customerData!.uid)
              .update({'profilePic': customerData!.profilePic});

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Imagen subida correctamente"))
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error al subir la imagen"))
          );
        }
      } catch (e) {
        print('Error updating profile pic: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al actualizar la imagen de perfil"))
        );
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(35),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    hexStringToColor("00ff2e"),
                    hexStringToColor("00ff8b"),
                    hexStringToColor("03f7ff")]
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewProfileScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            child: image_to_upload != null
                                ? ClipOval(
                              child: Image.file(
                                image_to_upload!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                                : customerData?.profilePic != null && customerData!.profilePic.isNotEmpty
                                ? ClipOval(
                              child: Image.network(
                                customerData!.profilePic,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                                : const Icon(Icons.person, size: 40, color: Colors.white),
                          ),
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: hexStringToColor("00ff2e"),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                final imagen = await selectImage();
                                if (imagen != null) {
                                  setState(() {
                                    image_to_upload = File(imagen.path);
                                  });
                                  await _updateProfilePic();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customerData != null
                                  ? "${customerData!.name} ${customerData!.surname}"
                                  : 'Usuario',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              'Ver perfil',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              // Humanity Provider Banner
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProviderInfoScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.business, color: Colors.green),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¿Deseas ser un proveedor de Humanity?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Conoce más aquí',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2.0,
                                  decorationColor: Colors.green
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              // Configuration Section
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configuración',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Mi servicio',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyServiceScreen(),
                          ),
                        );
                      },
                    ),
                    if (showService)
                      _buildMenuItem(
                        icon: Icons.work_outline,
                        title: 'Mi Servicio',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyServiceScreen(),
                            ),
                          );
                        },
                      ),
                    _buildMenuItem(
                      icon: Icons.payment_outlined,
                      title: 'Métodos de pago',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentMethodsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notificaciones',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Política de Privacidad',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: 'Cerrar sesión',
                      onTap: _logout,
                      showDivider: false,
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
    Color? textColor,
  }) {
    return Column(
        children: [
        ListTile(
        leading: Icon(icon, color: textColor),
    title: Text(
    title,
    style: TextStyle(color: textColor),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    ),
    if (showDivider)
    const Divider(height: 1),
    ],
    );
    }
}