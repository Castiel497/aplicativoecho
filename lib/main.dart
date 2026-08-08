import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/config/theme.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/providers/purchase_provider.dart';
import 'package:consome_plus/providers/stats_provider.dart';
import 'package:consome_plus/screens/splash/splash_screen.dart';

/// Ponto de entrada do aplicativo CONSOME+
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar providers e dados locais aqui (futuro: Hive)
  
  runApp(const ConsomePlusApp());
}

/// Raiz do aplicativo CONSOME+
class ConsomePlusApp extends StatelessWidget {
  const ConsomePlusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Provider de Usuário
        /// Gerencia dados do usuário (nome, nível, XP, etc)
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        
        /// Provider de Compras
        /// Gerencia histórico de compras e análises
        ChangeNotifierProvider(
          create: (_) => PurchaseProvider(),
        ),
        
        /// Provider de Estatísticas
        /// Calcula estatísticas baseado em usuário e compras
        ChangeNotifierProxyProvider<UserProvider, StatsProvider>(
          create: (_) => StatsProvider(),
          update: (_, userProvider, statsProvider) {
            return statsProvider ?? StatsProvider();
          },
        ),
      ],
      child: MaterialApp(
        title: 'CONSOME+',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
