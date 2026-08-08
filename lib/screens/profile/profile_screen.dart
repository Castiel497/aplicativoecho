import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/config/theme.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/providers/purchase_provider.dart';
import 'package:consome_plus/providers/stats_provider.dart';
import 'package:consome_plus/utils/formatters.dart';

/// Tela de Perfil
/// Mostra informações do usuário e configurações
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
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
          final levelName = statsProvider.getLevelName(userProvider);
          final ecoScore = statsProvider.getEcoScore(
            userProvider,
            purchaseProvider,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header com foto e nome
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentGreen.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Text(
                              user.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.name,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.darkText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Nível ${user.level} - $levelName',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Estatísticas principais
                _buildStatsGrid(context, user, ecoScore),
                const SizedBox(height: 24),

                // Membro desde
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informações da Conta',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.mediumText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          context,
                          'Membro desde',
                          AppFormatters.formatDateShort(user.createdAt),
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          context,
                          'Última atualização',
                          AppFormatters.formatRelativeTime(user.updatedAt),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Seção de configurações
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.notifications_outlined),
                        title: const Text('Notificações'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Implementar notificações
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text('Sobre o App'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showAboutDialog(context),
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('Versão'),
                        trailing: const Text('1.0.0'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botão sair
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implementar logout
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair da Conta'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.dangerRed,
                    side: const BorderSide(color: AppColors.dangerRed),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Constrói grid de estatísticas
  Widget _buildStatsGrid(
    BuildContext context,
    dynamic user,
    int ecoScore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suas Estatísticas',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatCard(
              context,
              '⭐',
              'XP Total',
              AppFormatters.formatNumber(user.totalEcoXP),
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              context,
              '🎯',
              'ECO SCORE',
              ecoScore.toString(),
            ),
          ],
        ),
      ],
    );
  }

  /// Constrói card de estatística
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
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
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

  /// Constrói linha de informação
  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.mediumText,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Mostra diálogo sobre
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre CONSOME+'),
        content: const Text(
          'CONSOME+ - Pense antes de comprar.\n\n'
          'Um aplicativo para ajudar você a fazer compras mais conscientes, '
          'economizando dinheiro e protegendo o planeta.\n\n'
          'Versão 1.0.0',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
