import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/config/theme.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/providers/purchase_provider.dart';
import 'package:consome_plus/models/purchase_model.dart';
import 'package:consome_plus/utils/formatters.dart';

/// Tela de Impacto do Usuário
/// Mostra histórico de compras e estatísticas
class MyImpactScreen extends StatelessWidget {
  const MyImpactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Impacto'),
        centerTitle: true,
      ),
      body: Consumer2<UserProvider, PurchaseProvider>(
        builder: (context, userProvider, purchaseProvider, _) {
          if (userProvider.user == null) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
              ),
            );
          }

          final user = userProvider.user!;
          final purchasesAvoided = purchaseProvider.getPurchasesAvoided();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Resumo de impacto
                _buildImpactSummary(context, user),
                const SizedBox(height: 24),

                // Estatísticas detalhadas
                _buildDetailedStats(context, user),
                const SizedBox(height: 24),

                // Histórico de compras
                _buildHistorySection(context, purchaseProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Constrói resumo de impacto
  Widget _buildImpactSummary(BuildContext context, dynamic user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seu Impacto',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.darkText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildImpactRow(
              context,
              '💰',
              'Dinheiro Economizado',
              AppFormatters.formatCurrency(user.moneyPreserved),
            ),
            const Divider(height: 20),
            _buildImpactRow(
              context,
              '🎯',
              'Compras Evitadas',
              user.purchasesAvoided.toString(),
            ),
            const Divider(height: 20),
            _buildImpactRow(
              context,
              '⭐',
              'Total de XP',
              AppFormatters.formatXP(user.totalEcoXP, showPlus: false),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói linha de impacto
  Widget _buildImpactRow(
    BuildContext context,
    String emoji,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.darkText,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Constrói estatísticas detalhadas
  Widget _buildDetailedStats(BuildContext context, dynamic user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Sustentáveis',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatBox(
              context,
              '🔧',
              'Consertados',
              user.productsRepaired.toString(),
            ),
            const SizedBox(width: 8),
            _buildStatBox(
              context,
              '♻️',
              'Reutilizados',
              user.productsReused.toString(),
            ),
            const SizedBox(width: 8),
            _buildStatBox(
              context,
              '🎁',
              'Doados',
              user.productsDonated.toString(),
            ),
          ],
        ),
      ],
    );
  }

  /// Constrói caixa de estatística
  Widget _buildStatBox(
    BuildContext context,
    String emoji,
    String label,
    String value,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.mediumText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói seção de histórico
  Widget _buildHistorySection(
    BuildContext context,
    PurchaseProvider purchaseProvider,
  ) {
    final purchases = purchaseProvider.purchases;

    if (purchases.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Text(
                  '📝',
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 12),
                Text(
                  'Nenhuma compra analisada ainda',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.mediumText,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Histórico de Análises',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        ...purchases.map((purchase) => _buildPurchaseHistoryItem(
          context,
          purchase,
        )),
      ],
    );
  }

  /// Constrói item do histórico
  Widget _buildPurchaseHistoryItem(
    BuildContext context,
    Purchase purchase,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        purchase.productName,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        purchase.category,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.mediumText,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      purchase.result.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppFormatters.formatCurrency(purchase.price),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Analisada ${AppFormatters.formatRelativeTime(purchase.analyzedAt)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
