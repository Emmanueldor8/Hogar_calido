import 'package:flutter/material.dart';

import 'productos.dart';

class CartPage extends StatefulWidget {
  const CartPage({required this.items, super.key});

  final List<Product> items;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get _total => widget.items.fold(0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: widget.items.isEmpty
          ? const Center(child: Text('Tu carrito esta vacio'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.items.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, index) {
                      final product = widget.items[index];
                      return ListTile(
                        leading: Icon(product.icon),
                        title: Text(product.name),
                        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          tooltip: 'Quitar del carrito',
                          onPressed: () =>
                              setState(() => widget.items.removeAt(index)),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${_total.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.payment),
                        label: const Text('Comprar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
