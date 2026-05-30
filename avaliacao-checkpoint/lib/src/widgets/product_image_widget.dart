import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget de imagem com loading, fallback temático e sem cache problemático
class ProductImageWidget extends StatelessWidget {
  final String imageUrl;
  final String categoria;
  final double height;

  const ProductImageWidget({
    super.key,
    required this.imageUrl,
    required this.categoria,
    this.height = 200,
  });

  IconData get _icone {
    switch (categoria.toLowerCase()) {
      case 'periféricos': return Icons.keyboard;
      case 'áudio':       return Icons.headset;
      case 'monitores':   return Icons.monitor;
      case 'móveis':      return Icons.chair;
      case 'hardware':    return Icons.memory;
      case 'controles':   return Icons.sports_esports;
      default:            return Icons.devices_other;
    }
  }

  Color get _cor {
    switch (categoria.toLowerCase()) {
      case 'periféricos': return const Color(0xFF780BF7);
      case 'áudio':       return const Color(0xFFFF55DF);
      case 'monitores':   return const Color(0xFF00BFFF);
      case 'móveis':      return const Color(0xFFFF8C00);
      case 'hardware':    return const Color(0xFF8FFF24);
      case 'controles':   return const Color(0xFFFF4500);
      default:            return const Color(0xFF780BF7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        // Forçar sem cache para pegar a nova URL
        cacheHeight: null,
        headers: const {
          'User-Agent': 'Mozilla/5.0 Flutter App',
        },
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _buildPlaceholder(loading: true);
        },
        errorBuilder: (_, __, ___) => _buildPlaceholder(loading: false),
      ),
    );
  }

  Widget _buildPlaceholder({required bool loading}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _cor.withOpacity(0.18),
            const Color(0xFF0D0D0D),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading)
            CircularProgressIndicator(color: _cor, strokeWidth: 2)
          else
            Icon(_icone, color: _cor, size: 64),
          const SizedBox(height: 12),
          Text(
            loading ? 'Carregando...' : categoria,
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: _cor.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
