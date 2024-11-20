import 'package:flutter/material.dart';
import 'package:humanity/utils/color_utils.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidad'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Política de Privacidad de Humanity',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Recopilación de Información',
              'Recopilamos información personal que usted nos proporciona directamente, '
                  'incluyendo nombre, dirección de correo electrónico, número de teléfono y '
                  'ubicación cuando utiliza nuestros servicios.',
            ),
            _buildSection(
              'Uso de la Información',
              'Utilizamos la información recopilada para:\n'
                  '• Proporcionar y mantener nuestros servicios\n'
                  '• Procesar sus transacciones\n'
                  '• Enviar notificaciones relacionadas con el servicio\n'
                  '• Mejorar nuestros servicios',
            ),
            _buildSection(
              'Compartir Información',
              'Compartimos su información personal solo con proveedores de servicios '
                  'que necesitan acceder a dicha información para realizar trabajos en '
                  'nuestro nombre.',
            ),
            _buildSection(
              'Seguridad',
              'Implementamos medidas de seguridad diseñadas para proteger su '
                  'información personal contra acceso no autorizado y uso indebido.',
            ),
            _buildSection(
              'Sus Derechos',
              'Usted tiene derecho a:\n'
                  '• Acceder a su información personal\n'
                  '• Corregir datos inexactos\n'
                  '• Solicitar la eliminación de sus datos\n'
                  '• Oponerse al procesamiento de sus datos',
            ),
            const SizedBox(height: 24),
            Text(
              'Última actualización: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }
}
