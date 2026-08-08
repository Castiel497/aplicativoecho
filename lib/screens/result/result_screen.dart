import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/config/theme.dart';
import 'package:consome_plus/models/purchase_model.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/providers/purchase_provider.dart';
import 'package:consome_plus/services/purchase_service.dart';
import 'package:consome_plus/utils/formatters.dart';

/// Tela de Resultado da Pausa Consciente
/// Mostra resultado (🟢🟡🔴), XP, sugestões e botões de decisão
class ResultScreen extends StatefulWidget {
  final Purchase purchase;

  const ResultScreen({
    Key? key,
    required this.purchase,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool? _userDecision; // true = comprou, false = não comprou
  bool _isProcessing = false;

  /// Processa decisão do usuário
  Future<void> _processPurchaseDecision(bool bought) async {
    setState(() => _isProcessing = true);

    try {
      final userProvider = context.read<UserProvider>();
      final purchaseProvider = context.read<PurchaseProvider>();

      if (userProvider.user == null) throw Exception('Usuário não encontrado');

      // Registrar a compra
      purchaseProvider.addPurchase(widget.purchase);

      // Se não comprou, adicionar rewards
      if (!bought) {
        userProvider.addEcoXP(widget.purchase.ecoXPEarned);
        userProvider.addPurchaseAvoided();
        userProvider.addMoneyPreserved(widget.purchase.price);
      }

      if (mounted) {
        setState(() => _userDecision = bought);
        
        // Mostrar mensagem
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              bought
                  ? 'Tudo bem! Sua decisão foi registrada.'
                  : '🎉 Excelente! Você economizou ${AppFormatters.formatCurrency(widget.purchase.price)}',
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Voltar para Home após 2 segundos
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home',
              (route) => false,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao processar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.purchase.result;
    final suggestions = PurchaseService.getAlternativeSuggestions(
      result,
      widget.purchase.answers,
    );

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Resultado da Análise'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Resultado grande
              Card(
                color: _getResultColor(result).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        result.emoji,
                        style: const TextStyle(fontSize: 64),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        result.label,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: _getResultColor(result),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        result.description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.mediumText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Informações do produto
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Produto Analisado',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.mediumText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.purchase.productName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.purchase.category,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AppColors.mediumText,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            AppFormatters.formatCurrency(
                              widget.purchase.price,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // XP Ganho (se não comprar)
              if (widget.purchase.ecoXPEarned > 0)
                Card(
                  color: AppColors.accentGreen.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '⭐ XP que você pode ganhar:',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        Text(
                          AppFormatters.formatXP(
                            widget.purchase.ecoXPEarned,
                          ),
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.accentGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Sugestões
              if (suggestions.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sugestões para você:',
                      style:
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...suggestions
                        .map((suggestion) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            suggestion,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.mediumText,
                                ),
                          ),
                        ))
                        .toList(),
                    const SizedBox(height: 24),
                  ],
                ),

              // Botões de decisão
              if (_userDecision == null) ...
                [
                  ElevatedButton.icon(
                    onPressed: _isProcessing
                        ? null
                        : () => _processPurchaseDecision(false),
                    icon: const Icon(Icons.thumb_up_outlined),
                    label: const Text('Não Vou Comprar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _isProcessing
                        ? null
                        : () => _processPurchaseDecision(true),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Vou Comprar Mesmo Assim'),
                  ),
                ]
              else
                SizedBox(
                  height: 50,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Retorna cor baseada no resultado
  Color _getResultColor(ConsciousPauseResult result) {
    switch (result) {
      case ConsciousPauseResult.conscientious:
        return AppColors.successGreen;
      case ConsciousPauseResult.thinkBetter:
        return AppColors.warningYellow;
      case ConsciousPauseResult.unnecessary:
        return AppColors.dangerRed;
    }
  }
}
