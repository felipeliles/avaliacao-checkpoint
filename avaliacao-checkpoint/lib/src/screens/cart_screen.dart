// Req 4  – ListenableBuilder
// Req 12 – Lógica completa do carrinho
// Req 13 – SnackBar + AlertDialog (checkout sem login)
// Req 8  – Navegação

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_notifier.dart';
import '../services/cart_service.dart';
import '../models/cart_item_model.dart';
import 'login_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Meu Carrinho',
            style: TextStyle(
                fontFamily: GoogleFonts.orbitron().fontFamily,
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          // Req 4 – ListenableBuilder para botão limpar
          ListenableBuilder(
            listenable: CartService.instance,
            builder: (_, __) {
              if (CartService.instance.itens.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => _confirmarLimpar(context),
                child: Text('Limpar',
                    style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.redAccent, fontWeight: FontWeight.w600)),
              );
            },
          ),
        ],
      ),
      // Req 4 – ListenableBuilder reconstrói a lista quando o carrinho muda
      body: ListenableBuilder(
        listenable: CartService.instance,
        builder: (context, _) {
          final cart = CartService.instance;
          if (cart.itens.isEmpty) return _buildVazio(context);
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.listaItens.length,
                  // Req 11 – ListView.builder
                  itemBuilder: (context, index) =>
                      _CartItemTile(item: cart.listaItens[index]),
                ),
              ),
              _buildResumo(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVazio(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 90, color: Colors.white12),
          const SizedBox(height: 20),
          Text('Carrinho vazio',
              style: TextStyle(
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                  fontSize: 22, color: Colors.white38, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Adicione produtos para continuar',
              style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white24, fontSize: 14)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: Text('Ver Produtos',
                style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF780BF7), foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumo(BuildContext context, CartService cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${cart.totalItens} ${cart.totalItens == 1 ? "item" : "itens"}',
                  style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.white54, fontSize: 14)),
                Text(cart.totalPrecoFormatado,
                    style: TextStyle(
                        fontFamily: GoogleFonts.orbitron().fontFamily,
                        color: const Color(0xFF8FFF24), fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _finalizarCompra(context, cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF780BF7),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 8,
                  shadowColor: const Color(0xFF780BF7).withOpacity(0.5),
                ),
                child: Text('Finalizar Compra 🚀',
                    style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarLimpar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Limpar carrinho?',
            style: TextStyle(color: Colors.white,
                fontFamily: GoogleFonts.orbitron().fontFamily, fontSize: 16)),
        content: Text('Todos os itens serão removidos.',
            style: TextStyle(color: Colors.white54,
                fontFamily: GoogleFonts.poppins().fontFamily)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancelar',
                style: TextStyle(color: Colors.white54,
                    fontFamily: GoogleFonts.poppins().fontFamily)),
          ),
          TextButton(
            onPressed: () { CartService.instance.limparCarrinho(); Navigator.of(ctx).pop(); },
            child: Text('Limpar',
                style: TextStyle(color: Colors.redAccent,
                    fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _finalizarCompra(BuildContext context, CartService cart) {
    // Req 13 – AlertDialog impedindo checkout sem login
    if (!AuthNotifier.instance.logado) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          title: Text('Login necessário',
              style: TextStyle(color: const Color(0xFFFF55DF),
                  fontFamily: GoogleFonts.orbitron().fontFamily, fontSize: 16)),
          content: Text('Você precisa estar logado para finalizar a compra.',
              style: TextStyle(color: Colors.white70,
                  fontFamily: GoogleFonts.poppins().fontFamily, height: 1.5)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancelar',
                  style: TextStyle(color: Colors.white38,
                      fontFamily: GoogleFonts.poppins().fontFamily)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                // Req 8 – navega para login
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF780BF7)),
              child: Text('Fazer Login',
                  style: TextStyle(color: Colors.white,
                      fontFamily: GoogleFonts.poppins().fontFamily)),
            ),
          ],
        ),
      );
      return;
    }

    // Req 13 – AlertDialog de confirmação de pedido
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('🎉 Pedido Confirmado!',
            style: TextStyle(color: const Color(0xFF8FFF24),
                fontFamily: GoogleFonts.orbitron().fontFamily, fontSize: 16)),
        content: Text(
          'Seu pedido de ${cart.totalPrecoFormatado} foi recebido!\n\nEm breve você receberá um e-mail de confirmação.',
          style: TextStyle(color: Colors.white70,
              fontFamily: GoogleFonts.poppins().fontFamily, height: 1.5),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              CartService.instance.limparCarrinho();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF780BF7)),
            child: Text('Ótimo!',
                style: TextStyle(color: Colors.white,
                    fontFamily: GoogleFonts.poppins().fontFamily)),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItemModel item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A4A), width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(item.produto.imageUrl, width: 70, height: 70, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    width: 70, height: 70, color: const Color(0xFF2A2A4A),
                    child: const Icon(Icons.image_not_supported, color: Colors.white24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.produto.nome,
                    style: TextStyle(fontFamily: GoogleFonts.orbitron().fontFamily,
                        fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(item.produto.precoFormatado,
                    style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14, color: const Color(0xFF8FFF24), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          // Req 12 – controles de quantidade
          Column(
            children: [
              Row(
                children: [
                  _QtyBtn(icon: Icons.remove, onTap: () => cart.diminuirQuantidade(item.produto.id)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('${item.quantidade}',
                        style: TextStyle(fontFamily: GoogleFonts.orbitron().fontFamily,
                            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  _QtyBtn(icon: Icons.add, onTap: () => cart.adicionarProduto(item.produto)),
                ],
              ),
              const SizedBox(height: 4),
              Text(item.subtotalFormatado,
                  style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 11, color: Colors.white38)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFF780BF7).withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF780BF7).withOpacity(0.4)),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF780BF7)),
      ),
    );
  }
}
