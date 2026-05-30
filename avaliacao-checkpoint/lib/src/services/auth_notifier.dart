// Req 4 – ChangeNotifier para estado de autenticação
import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthNotifier extends ChangeNotifier {
  // Singleton
  AuthNotifier._internal();
  static final AuthNotifier instance = AuthNotifier._internal();
  factory AuthNotifier() => instance;

  final _service = AuthService.instance;

  bool get logado => _service.logado;
  String? get nomeUsuario => _service.nomeUsuario;
  String? get emailUsuario => _service.email;

  Future<void> init() async {
    await _service.init();
    notifyListeners();
  }

  Future<bool> login(String email, String senha) async {
    final ok = await _service.login(email, senha);
    if (ok) notifyListeners();
    return ok;
  }

  Future<void> logout() async {
    await _service.logout();
    notifyListeners();
  }
}
