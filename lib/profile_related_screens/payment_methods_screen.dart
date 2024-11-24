import 'package:flutter/material.dart';
import 'package:humanity/utils/color_utils.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  PaymentMethodsScreenState createState() => PaymentMethodsScreenState();
}

class PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Métodos de Pago'),
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
    'Tarjetas Guardadas',
    style: TextStyle(
    fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    ),
      const SizedBox(height: 16),
      _buildPaymentCard(
        'Visa terminada en 4242',
        'Expira 12/25',
        Icons.credit_card,
        true,
      ),
      _buildPaymentCard(
        'Mastercard terminada en 8353',
        'Expira 08/24',
        Icons.credit_card,
        false,
      ),
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: () {
          // Implement add payment method
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Agregar Método de Pago',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      const Text(
        'Historial de Pagos',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      _buildPaymentHistoryItem(
        'Servicio de Mecánica',
        '€120.00',
        '15 Mar 2024',
        'Completado',
        Colors.green,
      ),
      _buildPaymentHistoryItem(
        'Clase de Cocina',
        '€80.00',
        '10 Mar 2024',
        'Completado',
        Colors.green,
      ),
    ],
    ),
        ),
    );
  }

  Widget _buildPaymentCard(
      String title, String subtitle, IconData icon, bool isDefault) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDefault)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Principal',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Implement edit/delete card
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryItem(
      String service, String amount, String date, String status, Color statusColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}