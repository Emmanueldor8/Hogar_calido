import 'package:flutter/material.dart';

import 'carrito.dart';
import 'page_transitions.dart';

// ============================================================
// MODELO DE PRODUCTO
// ============================================================

class Product {
  const Product({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });

  final String name;
  final double price;
  final String image;
  final String category;
}

// ============================================================
// PRODUCTOS DE PRUEBA
// ============================================================

const products = [
  Product(
    name: 'Jarrón de Cerámica Blanco',
    price: 45.00,
    image: 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=800',
    category: 'Salón',
  ),
  Product(
    name: 'Cojín Lino Nude',
    price: 28.50,
    image: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800',
    category: 'Salón',
  ),
  Product(
    name: 'Lámpara Roble Natural',
    price: 110.00,
    image: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800',
    category: 'Dormitorio',
  ),
  Product(
    name: 'Espejo Sol Mimbre',
    price: 74.90,
    image: 'https://images.unsplash.com/photo-1618220179428-22790b461013?w=800',
    category: 'Dormitorio',
  ),
];

// ============================================================
// PÁGINA DE PRODUCTOS
// ============================================================

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // ----------------------------------------------------------
  // COLORES
  // ----------------------------------------------------------

  static const Color _background = Color(0xFFFDFCFB);
  static const Color _primary = Color(0xFFD97706);
  static const Color _text = Color(0xFF292524);
  static const Color _mutedText = Color(0xFF929292);
  static const Color _chipBackground = Color(0xFFFBF3ED);

  // ----------------------------------------------------------
  // ESTADO
  // ----------------------------------------------------------

  final List<Product> _cart = [];
  final Set<String> _favorites = {};

  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'Todo';
  int _selectedNavigation = 0;

  final List<String> _categories = [
    'Todo',
    'Salón',
    'Dormitorio',
    'Cocina',
    'Baño',
  ];

  // ----------------------------------------------------------
  // CARRITO
  // ----------------------------------------------------------

  void _openCart() {
    Navigator.of(
      context,
    ).push(futuristicRoute(builder: (_) => CartPage(items: _cart)));
  }

  void _addToCart(Product product) {
    setState(() {
      _cart.add(product);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} agregado al carrito'),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  // ----------------------------------------------------------
  // FAVORITOS
  // ----------------------------------------------------------

  void _toggleFavorite(Product product) {
    setState(() {
      if (_favorites.contains(product.name)) {
        _favorites.remove(product.name);
      } else {
        _favorites.add(product.name);
      }
    });
  }

  // ----------------------------------------------------------
  // PRODUCTOS FILTRADOS
  // ----------------------------------------------------------

  List<Product> get _filteredProducts {
    final search = _searchController.text.trim().toLowerCase();

    return products.where((product) {
      final matchesCategory =
          _selectedCategory == 'Todo' || product.category == _selectedCategory;

      final matchesSearch =
          search.isEmpty || product.name.toLowerCase().contains(search);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // ----------------------------------------------------------
  // LIBERAR CONTROLLER
  // ----------------------------------------------------------

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,

      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // BUSCADOR
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: _chipBackground,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        style: const TextStyle(fontSize: 14, color: _text),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Color(0xFF9CA0A6),
                            size: 23,
                          ),
                          hintText: 'Buscar decoración...',
                          hintStyle: TextStyle(
                            color: Color(0xFF8F8F96),
                            fontSize: 14,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // BOTÓN FILTROS
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _chipBackground,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.tune_rounded,
                        size: 21,
                        color: Color(0xFF625B57),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // CATEGORÍAS
            // ==================================================
            SizedBox(
              height: 88,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 22,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final selected = category == _selectedCategory;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? _primary : _chipBackground,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF625B57),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ==================================================
            // PRODUCTOS
            // ==================================================
            Expanded(
              child: _filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'No encontramos productos',
                        style: TextStyle(color: _mutedText),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.68,
                          ),
                      itemBuilder: (context, index) {
                        return _buildProductCard(_filteredProducts[index]);
                      },
                    ),
            ),
          ],
        ),
      ),

      // ========================================================
      // NAVEGACIÓN INFERIOR
      // ========================================================
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ==========================================================
  // TARJETA DE PRODUCTO
  // ==========================================================

  Widget _buildProductCard(Product product) {
    final favorite = _favorites.contains(product.name);

    return GestureDetector(
      onTap: () {
        _addToCart(product);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------
          // IMAGEN
          // ----------------------------------------------------
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,

                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return Container(
                          color: _chipBackground,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _primary,
                          ),
                        );
                      },

                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: _chipBackground,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: _mutedText,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ----------------------------------------------
                // FAVORITO
                // ----------------------------------------------
                Positioned(
                  top: 9,
                  right: 9,
                  child: GestureDetector(
                    onTap: () {
                      _toggleFavorite(product);
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        favorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 19,
                        color: favorite ? _primary : const Color(0xFF8B9295),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ----------------------------------------------------
          // NOMBRE
          // ----------------------------------------------------
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _text,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 3),

          // ----------------------------------------------------
          // PRECIO
          // ----------------------------------------------------
          Text(
            '${product.price.toStringAsFixed(2)} €',
            style: const TextStyle(
              color: _text,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // NAVEGACIÓN INFERIOR
  // ==========================================================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F1F1), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavigationItem(
                index: 0,
                icon: Icons.home_rounded,
                label: 'Inicio',
              ),
              _buildNavigationItem(
                index: 1,
                icon: Icons.search_rounded,
                label: 'Explorar',
              ),
              _buildNavigationItem(
                index: 2,
                icon: Icons.shopping_bag_outlined,
                label: 'Carrito',
                badge: _cart.length,
                onTap: _openCart,
              ),
              _buildNavigationItem(
                index: 3,
                icon: Icons.person_outline_rounded,
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // ITEM NAVEGACIÓN
  // ==========================================================

  Widget _buildNavigationItem({
    required int index,
    required IconData icon,
    required String label,
    int badge = 0,
    VoidCallback? onTap,
  }) {
    final selected = _selectedNavigation == index;

    return Expanded(
      child: InkWell(
        onTap:
            onTap ??
            () {
              setState(() {
                _selectedNavigation = index;
              });
            },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: selected ? _primary : const Color(0xFF9AA0A3),
                ),

                // BADGE DEL CARRITO
                if (badge > 0)
                  Positioned(
                    right: -8,
                    top: -7,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 17,
                        minHeight: 17,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: _primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badge > 9 ? '9+' : badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? _primary : const Color(0xFF9AA0A3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
