// Req 8  – Navegação com Navigator
// Req 4  – ListenableBuilder (estado reativo sem Provider)
// Req 11 – ListView.builder com fonte assíncrona
// Req 14 – CircularProgressIndicator + try-catch

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/custom_app_bar_widget.dart';
import '../widgets/hero_section_widget.dart';
import '../widgets/product_card_widget.dart';
import '../widgets/subscription_section_widget.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _promosKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  // Req 11 / 14 – estado de carregamento assíncrono
  late Future<List<ProductModel>> _futureProducts;

  @override
  void initState() {
    super.initState();
    // Req 2 – dispara GET /products ao abrir a tela
    _futureProducts = ProductService.instance.buscarProdutos();
  }

  void _scrollToPromos() {
    final ctx = _promosKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0D0D0D),
      // Req 10 – CustomAppBarWidget reutilizável
      appBar: CustomAppBarWidget(
        scaffoldKey: _scaffoldKey,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: AppDrawerWidget(onPromosPressed: _scrollToPromos),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HeroSectionWidget(),
            const SizedBox(height: 24),
            Padding(
              key: _promosKey,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Promos Especiais',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.orbitron().fontFamily, // Req 9
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Os melhores produtos geek com preços incríveis',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily, // Req 9
                  fontSize: 13,
                  color: Colors.white38,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Req 11 / 14 – FutureBuilder + CircularProgressIndicator
            FutureBuilder<List<ProductModel>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF780BF7),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return _buildErro();
                }
                final produtos = snapshot.data ?? produtosDestaque;
                // Req 11 – ListView.builder dinâmico
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: produtos.length,
                  itemBuilder: (context, index) =>
                      ProductCardWidget(produto: produtos[index]),
                );
              },
            ),

            const SizedBox(height: 20),
            const SubscriptionSectionWidget(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildErro() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          const Icon(Icons.wifi_off, color: Colors.white24, size: 48),
          const SizedBox(height: 12),
          Text(
            'Não foi possível carregar os produtos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: Colors.white38,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => setState(
                () => _futureProducts = ProductService.instance.buscarProdutos()),
            icon: const Icon(Icons.refresh, color: Color(0xFF780BF7)),
            label: Text('Tentar novamente',
                style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: const Color(0xFF780BF7))),
          ),
        ],
      ),
    );
  }
}
