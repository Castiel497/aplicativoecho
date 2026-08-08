import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/config/theme.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/screens/welcome/welcome_screen.dart';
import 'package:consome_plus/screens/main_navigation.dart';

/// Splash Screen do CONSOME+
/// Exibida por 2 segundos ao iniciar o app
/// Mostra o logo e slogan do aplicativo
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  /// Aguarda 2 segundos e navega para próxima tela
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Verificar se é primeira vez
    final userProvider = context.read<UserProvider>();
    
    if (userProvider.isFirstTime) {
      // Ir para Welcome Screen
      Navigator.of(context).pushReplacementNamed('/welcome');
    } else {
      // Ir para Home
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Texto principal
            Text(
              'CONSOME+',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Slogan
            Text(
              'Pense antes de comprar.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.accentGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 60),

            // Loading indicator
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.accentGreen,
                ),
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
