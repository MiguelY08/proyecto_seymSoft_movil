import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberSession = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header con imagen ──
              _buildHeader(),

              // ── Espacio para el logo que sobresale ──
              const SizedBox(height: 62),

              // ── Formulario ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Center(
                      child: Text(
                        'Papelería Magic',
                        style: GoogleFonts.lora(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        'SISTEMA ADMINISTRATIVO',
                        style: GoogleFonts.openSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.2,
                          color: const Color(0xFF004D77),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Label correo ──
                    Text(
                      'Correo electrónico',
                      style: GoogleFonts.openSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF244153),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: _emailController,
                      hint: 'admin@papeleriamagic.com',
                      prefixIcon: const _EmailIcon(),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 20),

                    // ── Label contraseña ──
                    Text(
                      'Contraseña',
                      style: GoogleFonts.openSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPasswordField(),

                    const SizedBox(height: 14),

                    // ── Recordar sesión ──
                    Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Checkbox(
                            value: _rememberSession,
                            onChanged: (value) {
                              setState(() {
                                _rememberSession = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF2B5F8E),
                            checkColor: Colors.white,
                            side: const BorderSide(
                              color: Color(0xFFB0C4D8),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Recordar sesión',
                          style: GoogleFonts.openSans(
                            fontSize: 13.5,
                            color: const Color(0xFF444444),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // ── Botón LOGIN ──
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B3D6B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'LOGIN',
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.5,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ── Footer ──
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.openSans(
                            fontSize: 10,
                            color: const Color(0xFFBBBBBB),
                            letterSpacing: 0.8,
                          ),
                          children: [
                            const TextSpan(text: 'POWERED BY '),
                            TextSpan(
                              text: 'SEYMSOFT',
                              style: GoogleFonts.openSans(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF777777),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const TextSpan(text: ' © 2026'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header con imagen de fondo y logo real sobresaliente ──
  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Imagen de fondo del header
        SizedBox(
          width: double.infinity,
          height: 190,
          child: Image.asset(
            'assets/images/imagenparalamovil.jpeg',
            fit: BoxFit.cover,
          ),
        ),

        // Logo circular con imagen real de la empresa
        Positioned(
          bottom: -50,
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/PapeleriaMagicLogo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Campo de texto genérico ──
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required Widget prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE3EC), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.openSans(
          fontSize: 13.5,
          color: const Color(0xFF999999),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.openSans(
            fontSize: 13.5,
            color: const Color(0xFFBBBBBB),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: prefixIcon,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 10,
            minHeight: 10,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  // ── Campo contraseña con toggle ──
  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE3EC), width: 1),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: GoogleFonts.openSans(
          fontSize: 13.5,
          color: const Color(0xFF999999),
        ),
        decoration: InputDecoration(
          hintText: '••••••••',
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xFFBBBBBB),
            letterSpacing: 2,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: _LockIcon(),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 10,
            minHeight: 10,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.remove_red_eye_outlined
                  : Icons.visibility_off_outlined,
              color: const Color(0xFFBBBBBB),
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}

// ── Ícono sobre ──
class _EmailIcon extends StatelessWidget {
  const _EmailIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _EnvelopePainter()),
    );
  }
}

class _EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBBBBBB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 2, size.width, size.height - 2),
        const Radius.circular(2),
      ),
      paint,
    );
    canvas.drawLine(
      Offset(0, 2),
      Offset(size.width / 2, size.height / 2 + 1),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 2),
      Offset(size.width / 2, size.height / 2 + 1),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Ícono candado ──
class _LockIcon extends StatelessWidget {
  const _LockIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _LockPainter()),
    );
  }
}

class _LockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBBBBBB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.1,
          size.height * 0.45,
          size.width * 0.8,
          size.height * 0.5,
        ),
        const Radius.circular(3),
      ),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.25,
        size.height * 0.05,
        size.width * 0.5,
        size.height * 0.5,
      ),
      3.14159,
      3.14159,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}