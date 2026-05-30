import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionSectionWidget extends StatefulWidget {
  const SubscriptionSectionWidget({super.key});

  @override
  State<SubscriptionSectionWidget> createState() =>
      _SubscriptionSectionWidgetState();
}

class _SubscriptionSectionWidgetState
    extends State<SubscriptionSectionWidget> {
  final _emailController = TextEditingController();
  bool _inscrito = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _inscrever() {
    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: Text('Insira um e-mail válido.',
              style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
        ),
      );
      return;
    }
    setState(() => _inscrito = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF8FFF24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: _inscrito ? _buildSucesso() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        Text(
          'Inscreva-se para ganhar descontos!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.orbitron().fontFamily,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Cadastre seu email, receba novidades e descontos imperdíveis antes de todo mundo!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Digite seu melhor endereço de email',
            hintStyle:
                const TextStyle(color: Colors.black45, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 18, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _inscrever,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF780BF7),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              elevation: 6,
              shadowColor: const Color(0xFF780BF7).withOpacity(0.5),
            ),
            child: Text(
              'Inscrever',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSucesso() {
    return Column(
      children: [
        const Icon(Icons.check_circle, size: 52, color: Color(0xFF780BF7)),
        const SizedBox(height: 12),
        Text(
          '🎉 Você está dentro!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: GoogleFonts.orbitron().fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Em breve você receberá as melhores ofertas no seu e-mail.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
