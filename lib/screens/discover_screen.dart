import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.new_releases, 'label': 'Novedades'},
    {'icon': Icons.car_repair, 'label': 'Mecánica'},
    {'icon': Icons.security, 'label': 'Seguridad'},
    {'icon': Icons.restaurant, 'label': 'Comida'},
  ];

  final List<Map<String, dynamic>> _serviceProviders = [
    {
      'name': 'Anselma - Chef profesional',
      'category': 'Cocina mediterránea',
      'status': 'Disponible',
      'price': '\$70.000/hora',
      'rating': 4.87,
      'reviews': 71,
      'imageUrl': 'assets/chef.jpg',
    },
    {
      'name': 'Juan - Mecánico Automotriz',
      'category': 'Reparación',
      'specialties': ['Prevención', 'Diagnóstico'],
      'price': '\$50.000 - Revisión inicial',
      'rating': 5.0,
      'reviews': 3,
      'imageUrl': 'assets/mechanic.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildCategories(),
            Expanded(
              child: _buildServiceList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.black),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Busca tu servidor',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.swap_horiz, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _categories[index]['icon'],
                    color: _selectedCategoryIndex == index
                        ? Colors.green
                        : Colors.black,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _categories[index]['label'],
                    style: TextStyle(
                      color: _selectedCategoryIndex == index
                          ? Colors.green
                          : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  if (_selectedCategoryIndex == index)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      height: 2,
                      width: 40,
                      color: Colors.green,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _serviceProviders.length,
      itemBuilder: (context, index) {
        final provider = _serviceProviders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      provider['imageUrl'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          provider['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            Text(
                              ' ${provider['rating']} (${provider['reviews']})',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider['category'],
                      style: const TextStyle(color: Colors.black),
                    ),
                    if (provider['specialties'] != null) ...[
                      const SizedBox(height: 4),
                      ...provider['specialties'].map<Widget>((specialty) {
                        return Text(
                          specialty,
                          style: const TextStyle(color: Colors.black),
                        );
                      }).toList(),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      provider['price'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}