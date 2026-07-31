import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/cubit/auth_cubit.dart';

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
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el correo y la contraseña')),
      );
      return;
    }

    context.read<AuthCubit>().login(
      email: email,
      password: password,
      rememberSession: _rememberSession,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == AuthStatus.failure,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.errorMessage ?? 'No fue posible iniciar sesión',
            ),
          ),
        );
      },
      builder: (context, state) => Scaffold(
        backgroundColor: const Color(0xFFF1F3F6),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // ───── HEADER (BANNER + LOGO) ─────
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 180,
                            child: Image.asset(
                              'assets/images/imagenparalamovil.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),

                          Positioned(
                            bottom: -50,
                            child: Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Transform.scale(
                                  scale: 1.4, // 🔥 AJUSTA ENTRE 1.3 - 1.6
                                  child: Image.asset(
                                    'assets/images/PapeleriaMagicLogo.png',
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 60),

                      // ───── CONTENIDO ─────
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Papelería Magic',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Center(
                              child: Text(
                                'SISTEMA ADMINISTRATIVO',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                  color: Color(0xFF004D77),
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // EMAIL
                            const Text(
                              'Correo electrónico',
                              style: TextStyle(fontSize: 13.5),
                            ),
                            const SizedBox(height: 8),
                            _buildInputField(
                              controller: _emailController,
                              hint: 'admin@papeleriamagic.com',
                              icon: Icons.email_outlined,
                            ),

                            const SizedBox(height: 18),

                            // PASSWORD
                            const Text(
                              'Contraseña',
                              style: TextStyle(fontSize: 13.5),
                            ),
                            const SizedBox(height: 8),
                            _buildPasswordField(),

                            const SizedBox(height: 14),

                            // CHECKBOX
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberSession,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberSession = value ?? false;
                                    });
                                  },
                                  activeColor: const Color(0xFF2B5F8E),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Recordar sesión',
                                  style: TextStyle(fontSize: 13.5),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // BOTÓN LOGIN
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: state.status == AuthStatus.loading
                                    ? null
                                    : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1B3D6B),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: state.status == AuthStatus.loading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ───── INPUT EMAIL ─────
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE3EC)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.email],
        style: const TextStyle(fontSize: 13.5),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color(0xFFBBBBBB)),
        ),
      ),
    );
  }

  // ───── INPUT PASSWORD ─────
  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE3EC)),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.password],
        onSubmitted: (_) => _handleLogin(),
        style: const TextStyle(fontSize: 13.5),
        decoration: InputDecoration(
          hintText: '••••••••',
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFBBBBBB)),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: const Color(0xFFBBBBBB),
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),
    );
  }
}
