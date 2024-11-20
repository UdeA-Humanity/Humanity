import 'package:flutter/material.dart';
import 'package:humanity/utils/color_utils.dart';

class ProviderInfoScreen extends StatefulWidget {
  const ProviderInfoScreen({super.key});

  @override
  ProviderInfoScreenState createState() => ProviderInfoScreenState();
}

class ProviderInfoScreenState extends State<ProviderInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conviértete en Proveedor'),
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
        // Benefits Section
        const Card(
        child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Por qué unirse a Humanity?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            BenefitItem(
              icon: Icons.monetization_on_outlined,
              title: 'Ganancias Flexibles',
              description: 'Establece tus propias tarifas y horarios',
            ),
            BenefitItem(
              icon: Icons.people_outline,
              title: 'Amplía tu Red',
              description: 'Conecta con nuevos clientes en tu área',
            ),
            BenefitItem(
              icon: Icons.star_outline,
              title: 'Construye tu Reputación',
              description: 'Recibe calificaciones y reseñas',
            ),
          ],
        ),
      ),
    ),
    const SizedBox(height: 24),

    // Registration Form
    const Text(
    'Información del Servicio',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Service Category Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Categoría de Servicio',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: [
                        'Mecánico',
                        'Profesor',
                        'Chef',
                        'Electricista',
                        'Plomero',
                        'Carpintero',
                        'Otros'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione una categoría';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Service Description
                    TextFormField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descripción del Servicio',
                        prefixIcon: Icon(Icons.description_outlined),
                        hintText: 'Describe tu experiencia y servicios...',
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor ingrese una descripción';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Price Range
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Tarifa por Hora (€)',
                        prefixIcon: Icon(Icons.euro_outlined),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor ingrese una tarifa';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Service Area
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Área de Servicio',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        hintText: 'Ej: Madrid Centro, Radio 5km',
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor ingrese su área de servicio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Documents Upload Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Documentos Requeridos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DocumentUploadItem(
                              title: 'Identificación',
                              subtitle: 'DNI o Pasaporte',
                              icon: Icons.badge_outlined,
                            ),
                            DocumentUploadItem(
                              title: 'Certificaciones',
                              subtitle: 'Títulos o certificados profesionales',
                              icon: Icons.school_outlined,
                            ),
                            DocumentUploadItem(
                              title: 'Seguro de Responsabilidad Civil',
                              subtitle: 'Si aplica a tu servicio',
                              icon: Icons.security_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Terms and Conditions
                    CheckboxListTile(
                      title: const Text(
                        'Acepto los términos y condiciones',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: false,
                      onChanged: (bool? value) {},
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Implement registration logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Solicitud enviada correctamente'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Enviar Solicitud',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
        ),
      ),
    );
  }
}

// Widgets complementarios
class BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const BenefitItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentUploadItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const DocumentUploadItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: ElevatedButton.icon(
        onPressed: () {
          // Implement document upload
        },
        icon: const Icon(Icons.upload_file, size: 18),
        label: const Text('Subir'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}