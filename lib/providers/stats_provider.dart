import 'package:flutter/material.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/providers/purchase_provider.dart';

/// Provider para gerenciar estatísticas
/// Calcula dados agregados a partir de usuario e compras
class StatsProvider extends ChangeNotifier {
  /// Retorna o nível atual do usuário
  String? getUserLevel(UserProvider userProvider) {
    return userProvider.user?.level.toString();
  }

  /// Retorna nome do nível em português
  String? getLevelName(UserProvider userProvider) {
    if (userProvider.user == null) return null;
    
    const levelNames = {
      1: 'Consumidor Iniciante',
      2: 'Consumidor Consciente',
      3: 'Consumidor Sustentável',
      4: 'Guardião do Consumo',
      5: 'ECO MASTER',
    };
    
    return levelNames[userProvider.user!.level];
  }

  /// Retorna XP necessário para próximo nível
  int? getXPForNextLevel(UserProvider userProvider) {
    if (userProvider.user == null) return null;
    
    const xpPerLevel = {
      1: 0,
      2: 500,
      3: 1200,
      4: 2000,
      5: 3500,
    };
    
    final currentLevel = userProvider.user!.level;
    final nextLevel = currentLevel + 1;
    
    if (nextLevel > 5) return null; // Já é MASTER
    
    return xpPerLevel[nextLevel]!;
  }

  /// Retorna XP necessário para completar próximo nível
  int? getXPRemainingForNextLevel(UserProvider userProvider) {
    if (userProvider.user == null) return null;
    
    final xpNeeded = getXPForNextLevel(userProvider);
    if (xpNeeded == null) return null;
    
    final currentXP = userProvider.user!.totalEcoXP;
    final remaining = xpNeeded - currentXP;
    
    return remaining > 0 ? remaining : 0;
  }

  /// Retorna progresso para próximo nível (0-1)
  double? getLevelProgress(UserProvider userProvider) {
    if (userProvider.user == null) return null;
    
    const xpPerLevel = {
      1: 0,
      2: 500,
      3: 1200,
      4: 2000,
      5: 3500,
    };
    
    final currentLevel = userProvider.user!.level;
    if (currentLevel >= 5) return 1.0; // MASTER
    
    final currentLevelXP = xpPerLevel[currentLevel]!;
    final nextLevelXP = xpPerLevel[currentLevel + 1]!;
    final currentXP = userProvider.user!.totalEcoXP;
    
    final xpInCurrentLevel = currentXP - currentLevelXP;
    final xpNeededForLevel = nextLevelXP - currentLevelXP;
    
    return (xpInCurrentLevel / xpNeededForLevel).clamp(0.0, 1.0);
  }

  /// Retorna ECO SCORE (0-100)
  /// Baseado em histórico e decisões
  int getEcoScore(UserProvider userProvider, PurchaseProvider purchaseProvider) {
    if (userProvider.user == null) return 0;
    
    int score = 0;
    
    // 20 pontos por nível
    score += (userProvider.user!.level - 1) * 20;
    
    // Até 30 pontos por compras evitadas
    final purchasesAvoided = purchaseProvider.getPurchasesAvoided().length;
    score += (purchasesAvoided * 3).clamp(0, 30);
    
    // Até 20 pontos por ações sustentáveis
    final sustainableActions = 
      userProvider.user!.productsRepaired +
      userProvider.user!.productsReused +
      userProvider.user!.productsDonated;
    score += (sustainableActions * 2).clamp(0, 20);
    
    // Bônus até 30 pontos por participação contínua
    final daysSinceCreation = DateTime.now().difference(userProvider.user!.createdAt).inDays;
    score += (daysSinceCreation ~/ 3).clamp(0, 30);
    
    return score.clamp(0, 100);
  }

  /// Retorna categoria do ECO SCORE em português
  String getEcoScoreCategory(int score) {
    if (score >= 80) return 'Excelente! 🌟';
    if (score >= 60) return 'Muito Bom! 😊';
    if (score >= 40) return 'Bom! 👍';
    if (score >= 20) return 'Pode Melhorar 🤔';
    return 'Comece Agora! 🚀';
  }

  /// Retorna cor para visualizar ECO SCORE
  Color getEcoScoreColor(int score) {
    if (score >= 80) return const Color(0xFF2D7D3F); // Verde escuro
    if (score >= 60) return const Color(0xFF4CAF50); // Verde
    if (score >= 40) return const Color(0xFFFFC107); // Amarelo
    if (score >= 20) return const Color(0xFFFF9800); // Laranja
    return const Color(0xFFF44336); // Vermelho
  }

  /// Retorna resumo de impacto do usuário
  Map<String, dynamic> getImpactSummary(
    UserProvider userProvider,
    PurchaseProvider purchaseProvider,
  ) {
    if (userProvider.user == null) return {};
    
    final user = userProvider.user!;
    
    return {
      'moneyPreserved': user.moneyPreserved,
      'purchasesAvoided': user.purchasesAvoided,
      'productsRepaired': user.productsRepaired,
      'productsReused': user.productsReused,
      'productsDonated': user.productsDonated,
      'totalEcoXP': user.totalEcoXP,
      'level': user.level,
    };
  }
}
