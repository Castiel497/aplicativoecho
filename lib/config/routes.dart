import 'package:flutter/material.dart';
import 'package:consome_plus/screens/splash/splash_screen.dart';
import 'package:consome_plus/screens/welcome/welcome_screen.dart';
import 'package:consome_plus/screens/main_navigation.dart';
import 'package:consome_plus/screens/home/home_screen.dart';

/// Rotas da aplicação CONSOME+
/// Define a navegação entre as telas
class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String mainNavigation = '/main';
  static const String newPurchase = '/new-purchase';
  static const String result = '/result';
  static const String impact = '/impact';
  static const String challenges = '/challenges';
  static const String profile = '/profile';

  /// Retorna as rotas da aplicação
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      welcome: (context) => const WelcomeScreen(),
      home: (context) => const MainNavigation(),
      mainNavigation: (context) => const MainNavigation(),
      // TODO: Implementar outras rotas
      // newPurchase: (context) => const NewPurchaseScreen(),
      // result: (context) => const ResultScreen(),
      // impact: (context) => const MyImpactScreen(),
      // challenges: (context) => const ChallengesScreen(),
      // profile: (context) => const ProfileScreen(),
    };
  }
}
