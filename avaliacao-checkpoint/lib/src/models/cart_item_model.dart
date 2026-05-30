// Req 3 – Modelagem de dados: Item do Carrinho
import 'product_model.dart';

class CartItemModel {
  final ProductModel produto;
  int quantidade;

  CartItemModel({required this.produto, this.quantidade = 1});

  double get subtotal => produto.preco * quantidade;

  String get subtotalFormatado =>
      'R\$ ${subtotal.toStringAsFixed(2).replaceAll('.', ',')}';

  /// Req 3 – fromJson para reconstruir item a partir de dados persistidos
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      produto: ProductModel.fromJson(json['produto'] as Map<String, dynamic>),
      quantidade: json['quantidade'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'produto': produto.toJson(),
        'quantidade': quantidade,
      };
}
