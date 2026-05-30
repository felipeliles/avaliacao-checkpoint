// Req 5  – Singletons inicializados aqui
// Req 7  – AuthService.init() carrega token salvo (flutter_secure_storage)
// Req 15 – Assets configurados no pubspec.yaml

import 'package:flutter/material.dart';
import 'src/services/auth_notifier.dart';
import 'src/screens/initial_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Req 7 – carrega token JWT salvo no dispositivo antes de abrir o app
  await AuthNotifier.instance.init();
  runApp(const UseDevApp());
}

class UseDevApp extends StatelessWidget {
  const UseDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UseDev',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF780BF7)),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      ),
      home: const InitialScreen(),
    );
  }
}
