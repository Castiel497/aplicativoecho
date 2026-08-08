import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/config/theme.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/providers/purchase_provider.dart';
import 'package:consome_plus/providers/stats_provider.dart';
import 'package:consome_plus/utils/formatters.dart';

/// Home Screen do CONSOME+
/// Tela principal com dashboard de estatísticas
/// Mostra: saudação, dinheiro preservado, ECO SCORE, etc
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Carregar dados do usuário aqui
    // Por enquanto, usar dados mockados para demonstração
    _loadMockData();
  }

  /// Carrega dados mockados para demonstração
  void _loadMockData() {
    final userProvider = context.read<UserProvider>();
    final purchaseProvider = context.read<PurchaseProvider>();

    userProvider.loadMockUser();
    if (userProvider.user != null) {
      purchaseProvider.loadMockPurchases(userProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: _buildAppBar(context),
      body: Consumer3<UserProvider, PurchaseProvider, StatsProvider>(
        builder: (context, userProvider, purchaseProvider, statsProvider, _) {
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
          final ecoScore = statsProvider.getEcoScore(
            userProvider,
            purchaseProvider,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saudação
                _buildGreeting(context, user.name),
                const SizedBox(height: 24),

                // Cards de estatísticas principais
                _buildStatsRow(context, user),
                const SizedBox(height: 24),

                // ECO SCORE Card
                _buildEcoScoreCard(context, ecoScore, statsProvider),
                const SizedBox(height: 24),

                // Progresso de nível
                _buildLevelProgressCard(context, user, statsProvider),
                const SizedBox(height: 24),

                // Impacto do usuário
                _buildImpactSection(context, user),
                const SizedBox(height: 24),

                // Botão Nova Compra
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/new-purchase'),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Analisar Nova Compra'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Constrói AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('CONSOME+'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
      ],
    );
  }

  /// Constrói saudação
  Widget _buildGreeting(BuildContext context, String userName) {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Bom dia';
    } else if (hour < 18) {
      greeting = 'Boa tarde';
    } else {
      greeting = 'Boa noite';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $userName! 👋',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Vamos fazer compras mais conscientes?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.mediumText,
          ),
        ),
      ],
    );
  }

  /// Constrói linha com estatísticas principais
  Widget _buildStatsRow(BuildContext context, dynamic user) {
    return Row(
      children: [
        _buildStatCard(
          context,
          '💰',
          'Dinheiro\nPreservado',
          AppFormatters.formatCurrency(user.moneyPreserved),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          context,
          '⭐',
          'Compras\nEvitadas',
          user.purchasesAvoided.toString(),
        ),
      ],
    );
  }

  /// Constrói card de estatística individual
  Widget _buildStatCard(
    BuildContext context,
    String emoji,
    String label,
    String value,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.mediumText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói card de ECO SCORE
  Widget _buildEcoScoreCard(
    BuildContext context,
    int ecoScore,
    StatsProvider statsProvider,
  ) {
    final category = statsProvider.getEcoScoreCategory(ecoScore);
    final color = statsProvider.getEcoScoreColor(ecoScore);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ECO SCORE',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.mediumText,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: ecoScore / 100,
                          strokeWidth: 6,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          backgroundColor: AppColors.dividerColor,
                        ),
                      ),
                      Text(
                        '$ecoScore',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mantenha o ritmo!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.mediumText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói card de progresso de nível
  Widget _buildLevelProgressCard(
    BuildContext context,
    dynamic user,
    StatsProvider statsProvider,
  ) {
    final userProvider = context.read<UserProvider>();
    final levelName = statsProvider.getLevelName(userProvider);
    final progress = statsProvider.getLevelProgress(userProvider) ?? 0;
    final xpRemaining = statsProvider.getXPRemainingForNextLevel(userProvider) ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nível ${user.level}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      levelName ?? 'Desconhecido',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  AppFormatters.formatXP(user.totalEcoXP, showPlus: false),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Faltam $xpRemaining XP para o próximo nível',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mediumText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói seção de impacto
  Widget _buildImpactSection(BuildContext context, dynamic user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seu Impacto',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildImpactItem(
                context,
                '🔧',
                'Consertados',
                user.productsRepaired.toString(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildImpactItem(
                context,
                '♻️',
                'Reutilizados',
                user.productsReused.toString(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildImpactItem(
                context,
                '🎁',
                'Doados',
                user.productsDonated.toString(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Constrói item de impacto
  Widget _buildImpactItem(
    BuildContext context,
    String emoji,
    String label,
    String value,
  ) {
    return Card(
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
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.mediumText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
