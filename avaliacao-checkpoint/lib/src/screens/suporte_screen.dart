import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _Mensagem {
  final String texto;
  final bool isUsuario;
  final DateTime horario;

  _Mensagem({
    required this.texto,
    required this.isUsuario,
    required this.horario,
  });
}

class SuporteScreen extends StatefulWidget {
  const SuporteScreen({super.key});

  @override
  State<SuporteScreen> createState() => _SuporteScreenState();
}

class _SuporteScreenState extends State<SuporteScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _digitando = false;

  final List<_Mensagem> _mensagens = [
    _Mensagem(
      texto:
          '👾 Olá! Seja bem-vindo ao suporte UseDev!\nComo posso te ajudar hoje?',
      isUsuario: false,
      horario: DateTime.now(),
    ),
  ];

  // Respostas automáticas simuladas
  static const Map<String, String> _respostas = {
    'entrega': '🚚 Nossas entregas chegam em até 7 dias úteis para todo o Brasil. Frete grátis acima de R\$ 299,00!',
    'prazo': '🚚 Nossas entregas chegam em até 7 dias úteis para todo o Brasil. Frete grátis acima de R\$ 299,00!',
    'frete': '📦 Frete grátis para compras acima de R\$ 299,00. Abaixo disso, calculamos pelo CEP na hora do checkout.',
    'troca': '🔄 Aceitamos trocas e devoluções em até 30 dias após o recebimento. Basta entrar em contato pelo e-mail trocas@usedev.com.br.',
    'devolucao': '🔄 Aceitamos trocas e devoluções em até 30 dias após o recebimento. Basta entrar em contato pelo e-mail trocas@usedev.com.br.',
    'pagamento': '💳 Aceitamos cartão de crédito (até 12x), PIX e boleto bancário. PIX tem 5% de desconto!',
    'pix': '💳 PIX tem 5% de desconto! Após finalizar o pedido, você recebe o QR Code para pagamento.',
    'garantia': '🛡️ Todos os nossos produtos têm garantia mínima de 12 meses. Alguns itens possuem garantia estendida do fabricante.',
    'cancelar': '❌ Para cancelar um pedido, entre em contato em até 24h após a compra pelo e-mail pedidos@usedev.com.br ou pelo WhatsApp (81) 99999-0000.',
    'rastrear': '📍 Você pode rastrear seu pedido acessando "Meus Pedidos" no app e clicando em "Rastrear". O código de rastreio chega por e-mail em até 2 dias úteis.',
    'whatsapp': '📱 Nosso WhatsApp de suporte é (81) 99999-0000, disponível de segunda a sexta, das 9h às 18h.',
    'email': '📧 Nosso e-mail de suporte é suporte@usedev.com.br. Respondemos em até 24 horas úteis.',
    'desconto': '🎁 Assine nossa newsletter para receber cupons exclusivos! Novos clientes ganham 10% off na primeira compra com o cupom BEMVINDO10.',
    'cupom': '🎁 Insira o cupom no campo "Cupom de desconto" na tela de checkout. Nossos cupons ativos: BEMVINDO10 (10% off), GEEK20 (20% off em periféricos).',
    'produto': '🛒 Temos uma seleção incrível de periféricos, monitores, headsets, cadeiras e muito mais! Role a tela inicial para ver as promoções.',
  };

  String _gerarResposta(String mensagem) {
    final lower = mensagem.toLowerCase();
    for (final entry in _respostas.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return '🤔 Não entendi muito bem, mas nossa equipe pode te ajudar!\n\n📧 suporte@usedev.com.br\n📱 WhatsApp: (81) 99999-0000\n\nHorário de atendimento: Seg-Sex, 9h às 18h.';
  }

  Future<void> _enviarMensagem() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    _controller.clear();
    setState(() {
      _mensagens.add(_Mensagem(
        texto: texto,
        isUsuario: true,
        horario: DateTime.now(),
      ));
      _digitando = true;
    });
    _scrollToBottom();

    // Simula delay de digitação do suporte
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    setState(() {
      _digitando = false;
      _mensagens.add(_Mensagem(
        texto: _gerarResposta(texto),
        isUsuario: false,
        horario: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatarHorario(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF780BF7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.headset_mic, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suporte UseDev',
                  style: TextStyle(
                    fontFamily: GoogleFonts.orbitron().fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8FFF24),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Online agora',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 11,
                        color: const Color(0xFF8FFF24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chips de atalhos
          _buildAtalhos(),

          // Lista de mensagens
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _mensagens.length + (_digitando ? 1 : 0),
              itemBuilder: (context, index) {
                if (_digitando && index == _mensagens.length) {
                  return _buildDigitando();
                }
                final msg = _mensagens[index];
                return _buildBolha(msg);
              },
            ),
          ),

          // Campo de digitação
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildAtalhos() {
    final atalhos = [
      'Entrega',
      'Pagamento',
      'Troca',
      'Garantia',
      'Cupom',
      'Rastrear pedido',
    ];
    return Container(
      height: 44,
      color: const Color(0xFF0D0D0D),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: atalhos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => GestureDetector(
          onTap: () {
            _controller.text = atalhos[i];
            _enviarMensagem();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF780BF7)),
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF780BF7).withOpacity(0.12),
            ),
            child: Text(
              atalhos[i],
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 12,
                color: const Color(0xFFB47EFF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBolha(_Mensagem msg) {
    final isUser = msg.isUsuario;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: isUser ? 60 : 0,
          right: isUser ? 0 : 60,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF780BF7) : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.texto,
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 14,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatarHorario(msg.horario),
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 10,
                color: Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitando() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 6, bottom: 6, right: 60),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => _DotPulse(delay: i * 200)),
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        border: Border(top: BorderSide(color: Color(0xFF1A1A2E), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 14,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _enviarMensagem(),
                decoration: InputDecoration(
                  hintText: 'Digite sua mensagem...',
                  hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFF1A1A2E),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                        color: Color(0xFF780BF7), width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _enviarMensagem,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF780BF7),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF780BF7).withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animação de pontinhos "digitando"
class _DotPulse extends StatefulWidget {
  final int delay;
  const _DotPulse({required this.delay});

  @override
  State<_DotPulse> createState() => _DotPulseState();
}

class _DotPulseState extends State<_DotPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: FadeTransition(
        opacity: _anim,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF780BF7),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
