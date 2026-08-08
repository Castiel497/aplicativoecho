import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/config/theme.dart';
import 'package:consome_plus/utils/constants.dart';
import 'package:consome_plus/models/purchase_model.dart';
import 'package:consome_plus/services/purchase_service.dart';
import 'package:consome_plus/providers/user_provider.dart';

/// Pausa Consciente Screen
/// Exibe uma pergunta por vez para reflexão sobre a compra
class PauseConsciousScreen extends StatefulWidget {
  final String productName;
  final double price;
  final String category;

  const PauseConsciousScreen({
    Key? key,
    required this.productName,
    required this.price,
    required this.category,
  }) : super(key: key);

  @override
  State<PauseConsciousScreen> createState() => _PauseConsciousScreenState();
}

class _PauseConsciousScreenState extends State<PauseConsciousScreen> {
  int _currentQuestionIndex = 0;
  final Map<String, bool> _answers = {};
  bool _isLoading = false;

  /// Retorna pergunta atual
  Map<String, String> get _currentQuestion {
    return AppConstants.consciousPauseQuestions[_currentQuestionIndex];
  }

  /// Verifica se é última pergunta
  bool get _isLastQuestion {
    return _currentQuestionIndex ==
        AppConstants.consciousPauseQuestions.length - 1;
  }

  /// Avança para próxima pergunta ou vai para resultado
  Future<void> _nextQuestion(bool answer) async {
    final questionId = _currentQuestion['id']!;
    _answers[questionId] = answer;

    if (_isLastQuestion) {
      // Ir para resultado
      _goToResult();
    } else {
      // Próxima pergunta
      setState(() => _currentQuestionIndex++);
    }
  }

  /// Navega para tela de resultado
  Future<void> _goToResult() async {
    setState(() => _isLoading = true);

    try {
      final userProvider = context.read<UserProvider>();

      if (userProvider.user == null) {
        throw Exception('Usuário não encontrado');
      }

      // Criar objeto Purchase com as respostas
      final purchase = PurchaseService.createPurchase(
        userId: userProvider.user!.id,
        productName: widget.productName,
        price: widget.price,
        category: widget.category,
        answers: _answers,
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          '/result',
          arguments: purchase,
        );
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

  /// Volta para pergunta anterior
  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() => _currentQuestionIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pausa Consciente'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  '${_currentQuestionIndex + 1}/${AppConstants.consciousPauseQuestions.length}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Produto sendo analisado
              Card(
                color: AppColors.accentGreen.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Produto: ${widget.productName}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Preço: R\$ ${widget.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.mediumText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Pergunta
              Text(
                _currentQuestion['question']!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              // Barra de progresso
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) /
                      AppConstants.consciousPauseQuestions.length,
                  minHeight: 6,
                  backgroundColor: AppColors.dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accentGreen,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Botões de resposta
              ElevatedButton.icon(
                onPressed: _isLoading ? null : () => _nextQuestion(true),
                icon: const Icon(Icons.check_circle_outline),
                label: Text(_currentQuestion['yes']!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : () => _nextQuestion(false),
                icon: const Icon(Icons.cancel_outlined),
                label: Text(_currentQuestion['no']!),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botão voltar (se não é primeira pergunta)
              if (_currentQuestionIndex > 0)
                OutlinedButton(
                  onPressed: _previousQuestion,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.mediumText,
                    ),
                  ),
                  child: const Text('Pergunta Anterior'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
