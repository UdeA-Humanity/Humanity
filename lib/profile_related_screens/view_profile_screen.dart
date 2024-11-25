import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:humanity/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:humanity/services/select_image.dart';
import 'package:humanity/services/upload_image.dart';
import '../models/customer.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  ViewProfileScreenState createState() => ViewProfileScreenState();
}

class ViewProfileScreenState extends State<ViewProfileScreen> {
  User? _currentUser;
  File? image_to_upload;
  bool showService = false;
  Customer? customerData;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexStringToColor("00ff2e"),
                hexStringToColor("00ff8b"),
                hexStringToColor("03f7ff")
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
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
                        width: 160,
                        height: 160,
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
            ),
            const SizedBox(height: 20),
            // Profile Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection('Información Personal', [
                    _buildInfoItem('Nombre', "${customerData!.name} ${customerData!.surname}"),
                    _buildInfoItem('Correo', '${customerData!.email}'),
                    _buildInfoItem('Identificación', '${customerData!.idnumber}'),
                  ]),
                  const SizedBox(height: 20),
                  _buildInfoSection('Historial de Servicios', [
                    _buildServiceHistoryItem(
                      'Servicio de Mecánica',
                      'Completado',
                      '15/03/2024',
                      Colors.green,
                    ),
                    _buildServiceHistoryItem(
                      'Clase de Cocina',
                      'Pendiente',
                      '20/03/2024',
                      Colors.orange,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold,)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildServiceHistoryItem(
      String service, String status, String date, Color statusColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(service,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(date, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}