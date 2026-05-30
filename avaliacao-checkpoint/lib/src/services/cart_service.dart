// Req 4  – ChangeNotifier (gerenciamento de estado simples)
// Req 5  – Singleton
// Req 12 – Lógica completa do carrinho

import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartService extends ChangeNotifier {
  // ── Singleton ──────────────────────────────────────────────────────────────
  CartService._internal();
  static final CartService instance = CartService._internal();
  factory CartService() => instance;

  // ── Estado ─────────────────────────────────────────────────────────────────
  final Map<String, CartItemModel> _itens = {};

  // ── Getters ────────────────────────────────────────────────────────────────
  Map<String, CartItemModel> get itens => Map.unmodifiable(_itens);

  List<CartItemModel> get listaItens => _itens.values.toList();

  int get totalItens =>
      _itens.values.fold(0, (sum, item) => sum + item.quantidade);

  double get totalPreco =>
      _itens.values.fold(0.0, (sum, item) => sum + item.subtotal);

  String get totalPrecoFormatado =>
      'R\$ ${totalPreco.toStringAsFixed(2).replaceAll('.', ',')}';

  bool contemProduto(String id) => _itens.containsKey(id);

  int quantidadeItem(String id) => _itens[id]?.quantidade ?? 0;

  // ── Req 12 – Lógica de carrinho ────────────────────────────────────────────

  /// Adiciona produto ou incrementa quantidade
  void adicionarProduto(ProductModel produto) {
    if (_itens.containsKey(produto.id)) {
      _itens[produto.id]!.quantidade++;
    } else {
      _itens[produto.id] = CartItemModel(produto: produto);
    }
    notifyListeners(); // Req 4 – notifica a UI
  }

  /// Remove produto completamente
  void removerProduto(String id) {
    _itens.remove(id);
    notifyListeners();
  }

  /// Diminui quantidade; remove se chegar a zero
  void diminuirQuantidade(String id) {
    if (!_itens.containsKey(id)) return;
    if (_itens[id]!.quantidade <= 1) {
      _itens.remove(id);
    } else {
      _itens[id]!.quantidade--;
    }
    notifyListeners();
  }

  /// Limpa o carrinho inteiro
  void limparCarrinho() {
    _itens.clear();
    notifyListeners();
  }
}
