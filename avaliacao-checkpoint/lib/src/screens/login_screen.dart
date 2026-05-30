// Req 2  – POST /auth/login
// Req 6  – JWT
// Req 7  – flutter_secure_storage (via AuthService)
// Req 13 – SnackBar + AlertDialog
// Req 14 – try-catch + CircularProgressIndicator

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _senhaVisivel = false;
  bool _carregando = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);

    // Req 14 – try-catch ao chamar o serviço
    try {
      // Req 2 – chama POST via AuthService (dentro de AuthNotifier)
      final sucesso = await AuthNotifier.instance
          .login(_emailController.text.trim(), _senhaController.text);

      if (!mounted) return;
      setState(() => _carregando = false);

      if (sucesso) {
        // Req 13 – SnackBar de confirmação
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color(0xFF8FFF24),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text('Login realizado com sucesso! 🎮',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily)),
        ));
        Navigator.of(context).pop();
      } else {
        // Req 13 – SnackBar de erro
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text('E-mail ou senha inválidos.',
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
        ));
      }
    } catch (e) {
      // Req 14 – captura erros inesperados
      setState(() => _carregando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade900,
        content: Text('Erro ao conectar: $e',
            style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Center(child: Image.asset('assets/logo_usedev.png', height: 55)),
                    const SizedBox(height: 40),
                    Text(
                      'Bem-vindo\nde volta! 👾',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: GoogleFonts.orbitron().fontFamily,
                        fontSize: 32, fontWeight: FontWeight.bold,
                        color: Colors.white, height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Entre na sua conta para continuar comprando',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14, color: Colors.white54),
                    ),
                    const SizedBox(height: 48),
                    _label('E-mail'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDeco(hint: 'seuemail@exemplo.com', icon: Icons.email_outlined),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Informe seu e-mail';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim()))
                          return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _label('Senha'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: !_senhaVisivel,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDeco(hint: '••••••••', icon: Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_senhaVisivel ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white54),
                          onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Informe sua senha';
                        if (v.length < 6) return 'Mínimo de 6 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    // Req 14 – CircularProgressIndicator enquanto carrega
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _carregando
                          ? const Center(child: CircularProgressIndicator(color: Color(0xFF780BF7)))
                          : ElevatedButton(
                              onPressed: _fazerLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF780BF7),
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 8,
                                shadowColor: const Color(0xFF780BF7).withOpacity(0.5),
                              ),
                              child: Text('Entrar',
                                  style: TextStyle(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Use qualquer e-mail válido e senha com 6+ caracteres para testar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12, color: Colors.white24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: TextStyle(
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontSize: 13, fontWeight: FontWeight.w600,
          color: Colors.white70, letterSpacing: 0.5));

  InputDecoration _inputDeco({required String hint, required IconData icon}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: Icon(icon, color: const Color(0xFF780BF7), size: 20),
        filled: true, fillColor: const Color(0xFF1A1A2E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2A2A4A), width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF780BF7), width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
        errorStyle: const TextStyle(color: Colors.redAccent),
      );
}
