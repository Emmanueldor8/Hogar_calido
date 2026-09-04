import 'package:flutter/material.dart';

import 'productos.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    required this.items,
    super.key,
  });

  final List<Product> items;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _imageSlideAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _imageScaleAnimation;

  static const Color _brown = Color(0xFF62443A);
  static const Color _lightBrown = Color(0xFFF4E8D5);
  static const Color _gold = Color(0xFFC47A22);
  static const Color _text = Color(0xFF55413A);
  static const Color _gray = Color(0xFF81756E);

  double get _total {
    return widget.items.fold(
      0,
      (sum, item) => sum + item.price,
    );
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.65,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.25,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _imageScaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.7,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (widget.items.isEmpty) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text('Producto añadido al carrito'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          backgroundColor: _brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  void _removeProduct(int index) {
    final productName = widget.items[index].name;

    setState(() {
      widget.items.removeAt(index);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$productName eliminado del carrito',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          backgroundColor: _brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return _buildEmptyCart();
    }

    final product = widget.items.first;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              // IMAGEN CON ANIMACIÓN
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _imageSlideAnimation,
                  child: ScaleTransition(
                    scale: _imageScaleAnimation,
                    child: _buildProductImage(product),
                  ),
                ),
              ),

              // INFORMACIÓN CON ANIMACIÓN
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _contentSlideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      25,
                      24,
                      30,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // TÍTULO
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 28,
                            height: 1.15,
                            fontWeight: FontWeight.bold,
                            color: _text,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // PRECIO + ESTRELLAS EN LA MISMA FILA
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                color: _gold,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Container(
                              width: 1,
                              height: 24,
                              color: const Color(0xFFE3DCD5),
                            ),

                            const SizedBox(width: 14),

                            const Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 17,
                                  color: Color(0xFFE2B323),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 17,
                                  color: Color(0xFFE2B323),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 17,
                                  color: Color(0xFFE2B323),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 17,
                                  color: Color(0xFFE2B323),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 17,
                                  color: Color(0xFFE2B323),
                                ),
                              ],
                            ),

                            const SizedBox(width: 6),

                            const Flexible(
                              child: Text(
                                '4.9 (12 reseñas)',
                                overflow:
                                    TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _gray,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // DESCRIPCIÓN
                        const Text(
                          'Descripción',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: _text,
                          ),
                        ),

                        const SizedBox(height: 11),

                        Container(
                          height: 1,
                          width: double.infinity,
                          color: const Color(0xFFE9E2DA),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          _getDescription(product),
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.75,
                            color: Color(0xFF716762),
                          ),
                        ),

                        const SizedBox(height: 22),

                        _buildInfoRow(
                          'Categoría',
                          product.category,
                        ),

                        _buildInfoRow(
                          'Material',
                          _getMaterial(product.category),
                        ),

                        _buildInfoRow(
                          'Acabado',
                          'Natural y artesanal',
                        ),

                        const SizedBox(height: 22),

                        // BOTÓN AÑADIR AL CARRITO
                        _AnimatedCartButton(
                          onPressed: _addToCart,
                        ),

                        // OTROS PRODUCTOS
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return SizedBox(
      height: 68,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 19,
            ),
            color: const Color(0xFF3E3733),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'ARTESANÍA',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Color(0xFF292421),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  size: 23,
                  color: Color(0xFF332C29),
                ),

                Positioned(
                  right: -8,
                  top: -8,
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 250,
                    ),
                    transitionBuilder:
                        (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Container(
                      key: ValueKey(
                        widget.items.length,
                      ),
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: _brown,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        widget.items.length > 9
                            ? '9+'
                            : '${widget.items.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // IMAGEN DEL PRODUCTO
  // =========================================================

  Widget _buildProductImage(Product product) {
    return Container(
      height: 355,
      width: double.infinity,
      color: _lightBrown,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            product.image,
            fit: BoxFit.cover,
            loadingBuilder: (
              context,
              child,
              loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              }

              return const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _brown,
                  ),
                ),
              );
            },
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return Container(
                color: _lightBrown,
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: Color(0xFF80665A),
                  ),
                ),
              );
            },
          ),

          // ÚNICO "HECHO A MANO"
          Positioned(
            right: 15,
            bottom: 15,
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: 1,
              ),
              duration: const Duration(
                milliseconds: 800,
              ),
              curve: Curves.easeOutBack,
              builder: (
                context,
                value,
                child,
              ) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.90,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: const Text(
                  'HECHO A MANO',
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.1,
                    color: _brown,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INFORMACIÓN
  // =========================================================

  Widget _buildInfoRow(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF7D736C),
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF665C56),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDescription(Product product) {
    switch (product.category) {
      case 'Salón':
        return 'Una pieza decorativa diseñada para aportar calidez y personalidad a tu hogar. Su estilo artesanal combina perfectamente con diferentes ambientes y estilos de decoración.';

      case 'Dormitorio':
        return 'Una pieza elegante pensada para crear un ambiente acogedor y natural. Su diseño aporta armonía y un toque artesanal a cualquier espacio.';

      case 'Cocina':
        return 'Un elemento funcional y decorativo elaborado para complementar tu cocina con un estilo cálido, natural y artesanal.';

      case 'Baño':
        return 'Una pieza sencilla y elegante que aporta un toque natural y artesanal a los espacios de tu hogar.';

      default:
        return 'Una pieza artesanal cuidadosamente seleccionada para darle personalidad, calidez y un estilo natural a tu hogar.';
    }
  }

  String _getMaterial(String category) {
    switch (category) {
      case 'Salón':
        return 'Material artesanal';

      case 'Dormitorio':
        return 'Madera natural';

      case 'Cocina':
        return 'Material natural';

      case 'Baño':
        return 'Material resistente';

      default:
        return 'Material artesanal';
    }
  }

  // =========================================================
  // OTROS PRODUCTOS
  // =========================================================

  Widget _buildOtherProduct(
    Product product,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      duration: Duration(
        milliseconds: 450 + (index * 120),
      ),
      curve: Curves.easeOutCubic,
      builder: (
        context,
        value,
        child,
      ) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              18 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF9F4),
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),
              child: Image.network(
                product.image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    width: 70,
                    height: 70,
                    color: _lightBrown,
                    child: const Icon(
                      Icons.image_outlined,
                      color: _brown,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _text,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _gold,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                _removeProduct(index);
              },
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
              ),
              color: const Color(0xFF8C7C73),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // CARRITO VACÍO
  // =========================================================

  Widget _buildEmptyCart() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: 1,
              ),
              duration: const Duration(
                milliseconds: 700,
              ),
              curve: Curves.easeOutBack,
              builder: (
                context,
                value,
                child,
              ) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(23),
                    decoration: const BoxDecoration(
                      color: _lightBrown,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 45,
                      color: _brown,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _text,
                    ),
                  ),

                  const SizedBox(height: 9),

                  const Text(
                    'Agrega una pieza artesanal para verla aquí.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: _gray,
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: 190,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.maybePop(
                          context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brown,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Volver a productos',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================
// BOTÓN ANIMADO "AÑADIR AL CARRITO"
// ===========================================================

class _AnimatedCartButton extends StatefulWidget {
  const _AnimatedCartButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  State<_AnimatedCartButton> createState() =>
      _AnimatedCartButtonState();
}

class _AnimatedCartButtonState
    extends State<_AnimatedCartButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(
        milliseconds: 120,
      ),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },
        onTapCancel: () {
          setState(() {
            _pressed = false;
          });
        },
        onTapUp: (_) {
          setState(() {
            _pressed = false;
          });

          widget.onPressed();
        },
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            // color: _brown,
            borderRadius:
                BorderRadius.circular(11),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2262443A),
                blurRadius: 15,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 20,
                color: Colors.white,
              ),

              SizedBox(width: 9),

              Text(
                'Añadir al carrito',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}