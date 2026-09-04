import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'productos.dart';
import 'page_transitions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Controladores de animación para el Intro Futurista
  late AnimationController _introController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeIntroAnimation;

  bool _showLogin = false;

  // Paleta de colores extraída del diseño
  static const Color _bgColor = Color(0xFFF7F2EB);
  static const Color _cardColor = Color(0xFFFAF6F0);
  static const Color _primaryColor = Color(0xFFD9730D);
  static const Color _accentGlow = Color(0xFFFF9E3D);
  static const Color _textDark = Color(0xFF5C2B0B);
  static const Color _textMuted = Color(0xFF8C827A);
  static const Color _inputBorderColor = Color(0xFFB3AAA2);

  @override
  void initState() {
    super.initState();

    // Controller de la secuencia inicial futurista
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // Controller de pulsación/rotación continua
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Escalado del portal futurista
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Transición de salida del Intro
    _fadeIntroAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.75, 0.95, curve: Curves.easeInOut),
      ),
    );

    // Aparecimiento suave del Formulario de Login
    // Ejecutar animación inicial
    _introController.forward();
    _introController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showLogin = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    _pulseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    // Transición fluida con desvanecimiento hacia la siguiente pantalla
    Navigator.of(
      context,
    ).pushReplacement(futuristicRoute(builder: (_) => const ProductsPage()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          // -------------------------------------------------------------
          // PANTALLA PRINCIPAL DE LOGIN (Aparece al terminar la animación)
          // -------------------------------------------------------------
          AnimatedOpacity(
            opacity: _showLogin ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 600),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Imagen superior decorativa
                  SizedBox(
                    height: size.height * 0.40,
                    width: double.infinity,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1000&auto=format&fit=crop',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Tarjeta inferior con bordes redondeados
                  Transform.translate(
                    offset: const Offset(0, -32),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 480),
                      decoration: const BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 32,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Hogar Cálido',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Crea el hogar que siempre soñaste',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, color: _textMuted),
                            ),
                            const SizedBox(height: 28),

                            // Campo Correo Electrónico
                            const Text(
                              'Correo Electrónico',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _buildInputDecoration(
                                'ejemplo@hogar.com',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Ingresa tu correo';
                                }
                                if (!value.contains('@')) {
                                  return 'Correo no válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),

                            // Campo Contraseña
                            const Text(
                              'Contraseña',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              obscuringCharacter: '•',
                              decoration: _buildInputDecoration('••••••••'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu contraseña';
                                }
                                if (value.length < 6) {
                                  return 'Mínimo 6 caracteres';
                                }
                                return null;
                              },
                            ),

                            // Botón ¿Olvidaste tu contraseña?
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                    color: _primaryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Botón Iniciar Sesión
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Enlace para registro
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '¿No tienes una cuenta? ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _textMuted,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Regístrate aquí',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // -------------------------------------------------------------
          // OVERLAY CON ANIMACIÓN FUTURISTA DE BIENVENIDA
          // -------------------------------------------------------------
          if (!_showLogin)
            FadeTransition(
              opacity: _fadeIntroAnimation,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color(0xFF2B1810), // Fondo cálido oscuro futurista
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Anillo de pulso/brillo holográfico
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 220 + (_pulseController.value * 25),
                          height: 220 + (_pulseController.value * 25),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withValues(
                                  alpha: 0.35 * (1 - _pulseController.value),
                                ),
                                blurRadius: 40,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Anillos geométricos giratorios
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _pulseController.value * 2 * math.pi,
                          child: CustomPaint(
                            size: const Size(200, 200),
                            painter: _FuturisticRingsPainter(),
                          ),
                        );
                      },
                    ),

                    // Ícono central con escala elástica
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: _cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _accentGlow.withValues(alpha: 0.6),
                              blurRadius: 25,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.home_work_rounded,
                          size: 50,
                          color: _primaryColor,
                        ),
                      ),
                    ),

                    // Texto de inicialización del sistema
                    Positioned(
                      bottom: 120,
                      child: Column(
                        children: [
                          const Text(
                            'HOGAR CÁLIDO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: const [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _accentGlow,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Iniciando experiencia...',
                                style: TextStyle(
                                  color: Color(0xFFD6C3B5),
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Estilo reutilizable para los inputs
  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFAFA8A0), fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: _inputBorderColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: _primaryColor, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}

// Custom Painter para los anillos holográficos futuristas
class _FuturisticRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paintRing = Paint()
      ..color = const Color(0xFFFF9E3D).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final paintDotted = Paint()
      ..color = const Color(0xFFD9730D).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawCircle(center, 80, paintRing);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 95),
      0,
      1.5,
      false,
      paintDotted,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 95),
      3.14,
      1.5,
      false,
      paintDotted,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
