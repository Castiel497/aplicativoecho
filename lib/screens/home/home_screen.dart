import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/providers/purchase_provider.dart';
import 'package:consome_plus/providers/stats_provider.dart';

/// Tela principal do aplicativo
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CONSOME+'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cartão do usuário
            _buildUserCard(context),
            const SizedBox(height: 24),
            
            // Estatísticas
            _buildStatsSection(context),
            const SizedBox(height: 24),
            
            // Últimas compras
            _buildPurchasesSection(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar adição de compra
        },
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }

  /// Cartão com informações do usuário
  Widget _buildUserCard(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return Card(
          elevation: 4,
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
                        const Text(
                          'Bem-vindo!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userProvider.userName.isEmpty
                              ? 'Usuário'
                              : userProvider.userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Nível ${userProvider.level}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Barra de XP
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (userProvider.xp % 1000) / 1000,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'XP: ${userProvider.xp % 1000}/1000',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Seção de estatísticas
  Widget _buildStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estatísticas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Consumer2<PurchaseProvider, StatsProvider>(
          builder: (context, purchaseProvider, statsProvider, _) {
            return Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    label: 'Total Gasto',
                    value: 'R\$ ${purchaseProvider.totalSpent.toStringAsFixed(2)}',
                    icon: Icons.money,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    label: 'Compras',
                    value: purchaseProvider.purchaseCount.toString(),
                    icon: Icons.shopping_bag,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Card de estatística
  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Seção de compras recentes
  Widget _buildPurchasesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Compras Recentes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Consumer<PurchaseProvider>(
          builder: (context, purchaseProvider, _) {
            if (purchaseProvider.purchases.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 48,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Nenhuma compra registrada',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: purchaseProvider.purchases.length,
              itemBuilder: (context, index) {
                final purchase = purchaseProvider.purchases[index];
                return ListTile(
                  title: Text(purchase.title),
                  subtitle: Text(purchase.category),
                  trailing: Text(
                    'R\$ ${purchase.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(
                    purchase.isPaused
                        ? Icons.pause_circle
                        : Icons.shopping_bag_outlined,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
