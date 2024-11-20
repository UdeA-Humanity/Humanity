import 'package:flutter/material.dart';
import 'package:humanity/utils/color_utils.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  bool pushEnabled = true;
  bool emailEnabled = true;
  bool smsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Settings
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configuración de Notificaciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationToggle(
                    'Notificaciones Push',
                    'Recibe notificaciones en tu dispositivo',
                    pushEnabled,
                        (value) => setState(() => pushEnabled = value),
                  ),
                  _buildNotificationToggle(
                    'Correo Electrónico',
                    'Recibe actualizaciones por correo',
                    emailEnabled,
                        (value) => setState(() => emailEnabled = value),
                  ),
                  _buildNotificationToggle(
                    'SMS',
                    'Recibe notificaciones por mensaje de texto',
                    smsEnabled,
                        (value) => setState(() => smsEnabled = value),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Recent Notifications
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notificaciones Recientes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationItem(
                    'Nuevo servicio solicitado',
                    'Juan requiere un servicio de mecánica',
                    '2 min',
                    true,
                  ),
                  _buildNotificationItem(
                    'Pago recibido',
                    'Has recibido un pago de €80.00',
                    '1 hora',
                    false,
                  ),
                  _buildNotificationItem(
                    'Calificación recibida',
                    'Has recibido una calificación de 5 estrellas',
                    '2 horas',
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
      String title, String message, String time, bool isNew) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: isNew ? Colors.green.withOpacity(0.1) : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.2),
          child: const Icon(Icons.notifications_outlined, color: Colors.green),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}