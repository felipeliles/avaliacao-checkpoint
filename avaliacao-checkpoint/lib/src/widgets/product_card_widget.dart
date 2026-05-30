// Req 4  – ListenableBuilder
// Req 9  – Google Fonts
// Req 10 – Widget reutilizável
// Req 13 – SnackBar ao adicionar

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';
import 'product_image_widget.dart';
import '../services/cart_service.dart';

class ProductCardWidget extends StatefulWidget {
  const ProductCardWidget({required this.produto, super.key});
  final ProductModel produto;

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _onAddToCart() {
    _scaleCtrl.reverse().then((_) => _scaleCtrl.forward());
    CartService.instance.adicionarProduto(widget.produto);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xFF780BF7),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF8FFF24), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${widget.produto.nome} adicionado!',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  // Ícone temático por categoria (fallback quando imagem falha)
  IconData _iconePorCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'periféricos':
        return Icons.keyboard;
      case 'áudio':
        return Icons.headset;
      case 'monitores':
        return Icons.monitor;
      case 'móveis':
        return Icons.chair;
      case 'hardware':
        return Icons.memory;
      case 'controles':
        return Icons.sports_esports;
      default:
        return Icons.devices_other;
    }
  }

  Color _corPorCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'periféricos':
        return const Color(0xFF780BF7);
      case 'áudio':
        return const Color(0xFFFF55DF);
      case 'monitores':
        return const Color(0xFF00BFFF);
      case 'móveis':
        return const Color(0xFFFF8C00);
      case 'hardware':
        return const Color(0xFF8FFF24);
      case 'controles':
        return const Color(0xFFFF4500);
      default:
        return const Color(0xFF780BF7);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cor = _corPorCategoria(widget.produto.categoria);
    final icone = _iconePorCategoria(widget.produto.categoria);

    return ListenableBuilder(
      listenable: CartService.instance,
      builder: (context, _) {
        final cart = CartService.instance;
        final noCarrinho = cart.contemProduto(widget.produto.id);

        return AnimatedBuilder(
          animation: _scaleCtrl,
          builder: (_, child) =>
              Transform.scale(scale: _scaleCtrl.value, child: child),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF1A1A2E),
              border: Border.all(
                color: noCarrinho
                    ? const Color(0xFF8FFF24).withOpacity(0.6)
                    : const Color(0xFF2A2A4A),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: noCarrinho
                      ? cor.withOpacity(0.25)
                      : Colors.black.withOpacity(0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Imagem ──────────────────────────────────────────────
                  Stack(
                    children: [
                      ProductImageWidget(
                        imageUrl: widget.produto.imageUrl,
                        categoria: widget.produto.categoria,
                        height: 200,
                      ),
                      // Badge categoria
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: cor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: cor.withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(icone, color: Colors.white, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                widget.produto.categoria,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Badge quantidade no carrinho
                      if (noCarrinho)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: AnimatedScale(
                            scale: 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF8FFF24),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF8FFF24),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Text(
                                '${cart.quantidadeItem(widget.produto.id)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // ── Info do produto ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                    child: Text(
                      widget.produto.nome,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.orbitron().fontFamily,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.produto.descricao,
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 13,
                        color: Colors.white54,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // ── Preço + botão ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'por apenas',
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 11,
                                color: Colors.white38,
                              ),
                            ),
                            Text(
                              widget.produto.precoFormatado,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: const Color(0xFF8FFF24),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _onAddToCart,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            decoration: BoxDecoration(
                              color: noCarrinho
                                  ? const Color(0xFF8FFF24)
                                  : const Color(0xFF780BF7),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: (noCarrinho
                                          ? const Color(0xFF8FFF24)
                                          : const Color(0xFF780BF7))
                                      .withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  noCarrinho
                                      ? Icons.add_shopping_cart
                                      : Icons.shopping_cart_outlined,
                                  color: noCarrinho ? Colors.black : Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  noCarrinho ? 'Mais um' : 'Comprar',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: noCarrinho ? Colors.black : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
