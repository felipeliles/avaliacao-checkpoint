import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_notifier.dart';
import '../services/cart_service.dart';
import '../screens/cart_screen.dart';
import '../screens/login_screen.dart';
import '../screens/suporte_screen.dart';

class AppDrawerWidget extends StatelessWidget {
  final VoidCallback? onPromosPressed;
  const AppDrawerWidget({super.key, this.onPromosPressed});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0D0D0D),
      child: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([AuthNotifier.instance, CartService.instance]),
          builder: (context, _) {
            final auth = AuthNotifier.instance;
            final cart = CartService.instance;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(auth),
                const SizedBox(height: 8),
                _DrawerItem(icon: Icons.home_outlined, label: 'Início',
                    onTap: () => Navigator.of(context).pop()),
                _DrawerItem(icon: Icons.local_offer_outlined, label: 'Promos Especiais',
                    onTap: () {
                      Navigator.of(context).pop();
                      Future.delayed(const Duration(milliseconds: 300), () => onPromosPressed?.call());
                    }),
                _DrawerItem(
                  icon: Icons.shopping_cart_outlined, label: 'Meu Carrinho',
                  badge: cart.totalItens > 0 ? '${cart.totalItens}' : null,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                  },
                ),
                _DrawerItem(icon: Icons.headset_mic_outlined, label: 'Suporte',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SuporteScreen()));
                    }),
                _DrawerItem(icon: Icons.info_outline, label: 'Sobre a UseDev',
                    onTap: () { Navigator.of(context).pop(); _mostrarSobre(context); }),
                const Spacer(),
                const Divider(color: Color(0xFF2A2A4A), thickness: 1),
                const SizedBox(height: 8),
                if (auth.logado)
                  _DrawerItem(icon: Icons.logout, label: 'Sair da conta',
                      color: Colors.redAccent,
                      onTap: () async { await auth.logout(); if (context.mounted) Navigator.of(context).pop(); })
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      icon: const Icon(Icons.login, size: 18),
                      label: Text('Entrar na conta',
                          style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF780BF7), foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(AuthNotifier auth) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF780BF7), Color(0xFF1A1A2E)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/logo_usedev.png', height: 36),
          const SizedBox(height: 20),
          if (auth.logado) ...[
            CircleAvatar(
              radius: 28, backgroundColor: const Color(0xFF8FFF24),
              child: Text((auth.nomeUsuario ?? 'U')[0].toUpperCase(),
                  style: TextStyle(fontFamily: GoogleFonts.orbitron().fontFamily,
                      fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Text(auth.nomeUsuario ?? '',
                style: TextStyle(fontFamily: GoogleFonts.orbitron().fontFamily,
                    fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(auth.emailUsuario ?? '',
                style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 12, color: Colors.white60)),
          ] else ...[
            Row(children: [
              const CircleAvatar(radius: 22, backgroundColor: Color(0xFF2A2A4A),
                  child: Icon(Icons.person_outline, color: Colors.white54, size: 26)),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Olá, visitante!',
                    style: TextStyle(fontFamily: GoogleFonts.orbitron().fontFamily,
                        fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                Text('Faça login para mais recursos',
                    style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 11, color: Colors.white54)),
              ]),
            ]),
          ],
        ],
      ),
    );
  }

  void _mostrarSobre(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('👾 UseDev',
            style: TextStyle(fontFamily: GoogleFonts.orbitron().fontFamily,
                color: const Color(0xFF8FFF24), fontSize: 20)),
        content: Text('Sua loja geek favorita!\n\nOs melhores produtos para gamers e devs com os melhores preços do mercado.',
            style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white70, height: 1.6, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Fechar',
                style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,
                    color: const Color(0xFF780BF7), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final Color? color;
  final VoidCallback onTap;
  const _DrawerItem({required this.icon, required this.label, required this.onTap, this.badge, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.white70;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Icon(icon, color: c, size: 22),
      title: Text(label, style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,
          fontSize: 15, color: c, fontWeight: FontWeight.w500)),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFFFF55DF), borderRadius: BorderRadius.circular(20)),
              child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            )
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
