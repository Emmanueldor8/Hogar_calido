import 'package:flutter/material.dart';

import 'carrito.dart';

class Product {
  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
  });

  final String name;
  final String description;
  final double price;
  final IconData icon;
}

const products = [
  Product(
    name: 'Lampara calida',
    description: 'Luz suave para tu sala',
    price: 349.90,
    icon: Icons.light,
  ),
  Product(
    name: 'Cojin artesanal',
    description: 'Textura comoda y decorativa',
    price: 189.50,
    icon: Icons.weekend,
  ),
  Product(
    name: 'Vela aromatica',
    description: 'Aroma de vainilla y canela',
    price: 129.00,
    icon: Icons.local_fire_department,
  ),
];

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<Product> _cart = [];

  void _openCart() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CartPage(items: _cart)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            tooltip: 'Abrir carrito',
            onPressed: _openCart,
            icon: Badge(
              isLabelVisible: _cart.isNotEmpty,
              label: Text('${_cart.length}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(child: Icon(product.icon)),
              title: Text(product.name),
              subtitle: Text(
                '${product.description}\n\$${product.price.toStringAsFixed(2)}',
              ),
              isThreeLine: true,
              trailing: IconButton(
                tooltip: 'Agregar al carrito',
                onPressed: () {
                  setState(() => _cart.add(product));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} agregado')),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
              ),
            ),
          );
        },
      ),
    );
  }
}
