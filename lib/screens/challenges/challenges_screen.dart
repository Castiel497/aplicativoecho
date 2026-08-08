import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/config/theme.dart';
import 'package:consome_plus/utils/constants.dart';
import 'package:consome_plus/data/mock_data.dart';
import 'package:consome_plus/models/challenge_model.dart';

/// Tela de Desafios
/// Mostra desafios disponíveis e completados
class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({Key? key}) : super(key: key);

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  late List<Challenge> _challenges;

  @override
  void initState() {
    super.initState();
    _challenges = MockData.createMockChallenges();
  }

  @override
  Widget build(BuildContext context) {
    final activeChallenges = _challenges.where((c) => !c.isCompleted).toList();
    final completedChallenges = _challenges.where((c) => c.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Desafios'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Desafios ativos
            if (activeChallenges.isNotEmpty) ...
              [
                Text(
                  'Desafios Ativos',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 12),
                ...activeChallenges.map((challenge) =>
                    _buildChallengeCard(context, challenge, false)),
                const SizedBox(height: 24),
              ],

            // Desafios completados
            if (completedChallenges.isNotEmpty) ...
              [
                Text(
                  'Desafios Completados',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 12),
                ...completedChallenges.map((challenge) =>
                    _buildChallengeCard(context, challenge, true)),
              ],

            if (activeChallenges.isEmpty && completedChallenges.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        '🎯',
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Nenhum desafio disponível',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.mediumText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Constrói card de desafio
  Widget _buildChallengeCard(
    BuildContext context,
    Challenge challenge,
    bool isCompleted,
  ) {
    final difficultyEmoji = challenge.getDifficultyColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isCompleted
          ? AppColors.successGreen.withOpacity(0.05)
          : AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    challenge.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? AppColors.mediumText
                          : AppColors.darkText,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                if (isCompleted)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      '✅',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              challenge.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mediumText,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      difficultyEmoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      challenge.difficulty,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.mediumText,
                      ),
                    ),
                  ],
                ),
                Text(
                  '+${challenge.xpReward} XP',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (!isCompleted) ...
              [
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Implementar marcar desafio como completo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Desafio marcado como completo! 🎉'),
                        ),
                      );
                    },
                    child: const Text('Completar Desafio'),
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}
