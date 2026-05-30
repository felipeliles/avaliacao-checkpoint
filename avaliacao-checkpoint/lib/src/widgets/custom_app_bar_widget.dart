// Req 9  – Google Fonts (Orbitron / Poppins)
// Req 10 – Widget customizado e reutilizável

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_notifier.dart';
import '../services/cart_service.dart';
import '../screens/cart_screen.dart';
import '../screens/login_screen.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final VoidCallback? onMenuTap;

  const CustomAppBarWidget({super.key, this.scaffoldKey, this.onMenuTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0D0D0D),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
        onPressed: onMenuTap ?? () => scaffoldKey?.currentState?.openDrawer(),
      ),
      // Req 15 – asset de logo declarado no pubspec
      title: Image.asset('assets/logo_usedev.png', height: 38),
      centerTitle: true,
      actions: [
        // Req 4 – ListenableBuilder para ícone de login reativo
        ListenableBuilder(
          listenable: AuthNotifier.instance,
          builder: (context, _) {
            final auth = AuthNotifier.instance;
            return IconButton(
              icon: Icon(
                auth.logado ? Icons.person : Icons.person_outline,
                color:
                    auth.logado ? const Color(0xFF8FFF24) : Colors.white,
                size: 28,
              ),
              onPressed: () {
                if (auth.logado) {
                  _mostrarMenuUsuario(context, auth);
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
            );
          },
        ),
        // Req 4 – ListenableBuilder para badge do carrinho reativo
        ListenableBuilder(
          listenable: CartService.instance,
          builder: (context, _) {
            final total = CartService.instance.totalItens;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white, size: 28),
                  // Req 8 – navegação para CartScreen
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  ),
                ),
                if (total > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF55DF),
                        shape: BoxShape.circle,
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        '$total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _mostrarMenuUsuario(BuildContext context, AuthNotifier auth) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44, height: 4,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 36,
              backgroundColor: const Color(0xFF780BF7),
              child: Text(
                (auth.nomeUsuario ?? 'U')[0].toUpperCase(),
                style: TextStyle(
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                  fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              auth.nomeUsuario ?? '',
              style: TextStyle(
                fontFamily: GoogleFonts.orbitron().fontFamily,
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
              ),
            ),
            Text(
              auth.emailUsuario ?? '',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 13, color: Colors.white38,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await auth.logout();
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: Text('Sair da conta',
                    style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
