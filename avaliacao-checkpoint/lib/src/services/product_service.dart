// Req 2  – Consumo de API REST (GET produtos)
// Req 3  – fromJson
// Req 14 – try-catch + fallback

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'auth_service.dart';

class ProductService {
  // Req 5 – Singleton
  ProductService._internal();
  static final ProductService instance = ProductService._internal();
  factory ProductService() => instance;

  static const _baseUrl = 'https://fakestoreapi.com';

  /// Req 2 – GET /products
  /// Req 3 – converte cada item com ProductModel.fromJson
  /// Req 14 – try-catch; retorna lista local em caso de falha
  Future<List<ProductModel>> buscarProdutos() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/products'),
            headers: AuthService.instance.authHeaders,
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((json) => _mapFakeStore(json as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Sem internet ou API fora – usa fallback
    }
    // Req 14 – fallback local
    return produtosDestaque;
  }

  /// Adapta o schema da FakeStore API para o nosso ProductModel
  ProductModel _mapFakeStore(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      nome: json['title']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? '',
      preco: (json['price'] ?? 0).toDouble(),
      categoria: json['category']?.toString() ?? '',
      descricao: json['description']?.toString() ?? '',
    );
  }
}
