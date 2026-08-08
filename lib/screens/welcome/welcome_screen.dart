import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/config/theme.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/utils/validators.dart';
import 'package:consome_plus/utils/constants.dart';

/// Welcome Screen do CONSOME+
/// Tela inicial para novos usuários
/// Coleta o nome do usuário e começa o app
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Cria novo usuário e navega para Home
  Future<void> _startApp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userProvider = context.read<UserProvider>();
      await userProvider.createUser(_nameController.text.trim());

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/Título
                Text(
                  'CONSOME+',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Slogan
                Text(
                  'Pense antes de comprar.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.accentGreen,
                  ),
                ),
                const SizedBox(height: 48),

                // Boas-vindas
                Text(
                  'Bem-vindo ao CONSOME+!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 16),

                // Descrição
                Text(
                  'Ajudamos você a fazer compras mais conscientes, '
                  'economizando dinheiro e protegendo o planeta.\n\n'
                  'Vamos começar?',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.mediumText,
                  ),
                ),
                const SizedBox(height: 40),

                // Campo de nome
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Seu nome',
                    prefixIcon: const Icon(Icons.person_outline),
                    filled: true,
                    fillColor: AppColors.white,
                  ),
                  validator: AppValidators.validateName,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _startApp(),
                ),
                const SizedBox(height: 24),

                // Botão de início
                ElevatedButton(
                  onPressed: _isLoading ? null : _startApp,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      : const Text('Começar'),
                ),
                const SizedBox(height: 24),

                // Features preview
                Text(
                  'O que você vai descobrir:',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 12),
                ..._buildFeaturesList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói lista de features
  List<Widget> _buildFeaturesList(BuildContext context) {
    final features = [
      '🎯 Pausa Consciente - Reflita antes de comprar',
      '💰 Dinheiro Preservado - Veja quanto você economiza',
      '📊 ECO SCORE - Acompanhe seu progresso',
      '⭐ Desafios - Ganhe XP e suba de nível',
      '📈 Impacto - Veja seu impacto no planeta',
    ];

    return features
        .map((feature) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            feature,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.mediumText,
            ),
          ),
        ))
        .toList();
  }
}
