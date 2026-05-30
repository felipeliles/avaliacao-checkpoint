// Req 3 – Modelagem de dados com fromJson
class ProductModel {
  final String id;
  final String nome;
  final String imageUrl;
  final double preco;
  final String categoria;
  final String descricao;

  const ProductModel({
    required this.id,
    required this.nome,
    required this.imageUrl,
    required this.preco,
    required this.categoria,
    required this.descricao,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      preco: (json['preco'] ?? json['price'] ?? 0).toDouble(),
      categoria: json['categoria']?.toString() ?? json['category']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'imageUrl': imageUrl,
        'preco': preco,
        'categoria': categoria,
        'descricao': descricao,
      };

  String get precoFormatado =>
      'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
}

// URLs do DummyJSON — API de produtos para testes, 100% confiável em Flutter mobile
final List<ProductModel> produtosDestaque = [
  ProductModel(
    id: '1',
    nome: 'Teclado Mecânico RGB',
    imageUrl: 'https://cdn.dummyjson.com/product-images/1/1.jpg',
    preco: 349.90,
    categoria: 'Periféricos',
    descricao: 'Teclado mecânico gamer com iluminação RGB personalizável e switches blue.',
  ),
  ProductModel(
    id: '2',
    nome: 'Mouse Gamer Pro 16000 DPI',
    imageUrl: 'https://cdn.dummyjson.com/product-images/2/1.jpg',
    preco: 189.90,
    categoria: 'Periféricos',
    descricao: 'Mouse gamer de alta precisão com sensor óptico de 16000 DPI e 7 botões programáveis.',
  ),
  ProductModel(
    id: '3',
    nome: 'Headset Surround 7.1',
    imageUrl: 'https://cdn.dummyjson.com/product-images/3/1.jpg',
    preco: 279.90,
    categoria: 'Áudio',
    descricao: 'Headset gamer com som surround virtual 7.1, microfone removível e almofadas de espuma.',
  ),
  ProductModel(
    id: '4',
    nome: 'Monitor Gamer 144Hz IPS',
    imageUrl: 'https://cdn.dummyjson.com/product-images/4/1.jpg',
    preco: 1299.90,
    categoria: 'Monitores',
    descricao: 'Monitor gamer 24" Full HD, taxa de 144Hz, tempo de resposta 1ms e painel IPS.',
  ),
  ProductModel(
    id: '5',
    nome: 'Cadeira Gamer Ergonômica',
    imageUrl: 'https://cdn.dummyjson.com/product-images/5/1.jpg',
    preco: 899.90,
    categoria: 'Móveis',
    descricao: 'Cadeira gamer com apoio lombar ajustável, encosto reclinável e braços 4D.',
  ),
  ProductModel(
    id: '6',
    nome: 'Placa de Vídeo RTX 4070',
    imageUrl: 'https://cdn.dummyjson.com/product-images/6/1.jpg',
    preco: 3499.90,
    categoria: 'Hardware',
    descricao: 'Placa de vídeo NVIDIA RTX 4070 com 12GB GDDR6X, ray tracing e DLSS 3.0.',
  ),
  ProductModel(
    id: '7',
    nome: 'Controle Sem Fio Pro',
    imageUrl: 'https://cdn.dummyjson.com/product-images/7/1.jpg',
    preco: 299.90,
    categoria: 'Controles',
    descricao: 'Controle sem fio compatível com PC, PS4 e PS5, com vibração dupla e entrada P2.',
  ),
  ProductModel(
    id: '8',
    nome: 'SSD NVMe 1TB 7000MB/s',
    imageUrl: 'https://cdn.dummyjson.com/product-images/8/1.jpg',
    preco: 549.90,
    categoria: 'Hardware',
    descricao: 'SSD NVMe PCIe 4.0 com velocidade de leitura de 7000MB/s e escrita de 6500MB/s.',
  ),
];
