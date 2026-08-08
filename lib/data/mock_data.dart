import 'package:consome_plus/models/user_model.dart';
import 'package:consome_plus/models/purchase_model.dart';
import 'package:consome_plus/models/challenge_model.dart';

/// Dados mockados para testes e desenvolvimento
class MockData {
  /// Usuário padrão de teste
  static User createMockUser({String? id, String? name}) {
    final now = DateTime.now();
    return User(
      id: id ?? 'user_001',
      name: name ?? 'João Silva',
      level: 2,
      totalEcoXP: 450,
      moneyPreserved: 1250.50,
      purchasesAvoided: 5,
      productsRepaired: 2,
      productsReused: 3,
      productsDonated: 1,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    );
  }

  /// Exemplos de compras analisadas
  static List<Purchase> createMockPurchases(String userId) {
    final now = DateTime.now();
    return [
      Purchase(
        id: 'purchase_001',
        userId: userId,
        productName: 'Fone de Ouvido',
        price: 150.00,
        category: 'Eletrônicos',
        analyzedAt: now.subtract(const Duration(days: 7)),
        answers: {
          'needsIt': false,
          'alreadyHas': true,
          'currentWorks': true,
          'canRepair': false,
          'canReuse': false,
          'canBuyUsed': false,
        },
        result: ConsciousPauseResult.conscientious,
        ecoXPEarned: 100,
        finalDecision: false,
        decidedAt: now.subtract(const Duration(days: 7)),
      ),
      Purchase(
        id: 'purchase_002',
        userId: userId,
        productName: 'Blusa de Frio',
        price: 89.90,
        category: 'Roupas',
        analyzedAt: now.subtract(const Duration(days: 14)),
        answers: {
          'needsIt': true,
          'alreadyHas': false,
          'currentWorks': true,
          'canRepair': false,
          'canReuse': false,
          'canBuyUsed': true,
        },
        result: ConsciousPauseResult.thinkBetter,
        ecoXPEarned: 75,
        finalDecision: true,
        decidedAt: now.subtract(const Duration(days: 14)),
      ),
      Purchase(
        id: 'purchase_003',
        userId: userId,
        productName: 'Espelho Decorativo',
        price: 200.00,
        category: 'Casa',
        analyzedAt: now.subtract(const Duration(days: 21)),
        answers: {
          'needsIt': false,
          'alreadyHas': false,
          'currentWorks': false,
          'canRepair': false,
          'canReuse': false,
          'canBuyUsed': false,
        },
        result: ConsciousPauseResult.unnecessary,
        ecoXPEarned: 0,
        finalDecision: false,
        decidedAt: now.subtract(const Duration(days: 21)),
      ),
    ];
  }

  /// Exemplos de desafios
  static List<Challenge> createMockChallenges() {
    final now = DateTime.now();
    return [
      Challenge(
        id: 'challenge_001',
        title: 'Ficar 7 dias sem compras por impulso',
        description: 'Resista à tentação e não faça compras por impulso durante 7 dias',
        xpReward: 300,
        difficulty: 'Médio',
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 30)),
        completedAt: now.subtract(const Duration(days: 23)),
      ),
      Challenge(
        id: 'challenge_002',
        title: 'Consertar algo antes de comprar outro',
        description: 'Encontre algo quebrado em casa e conserte-o ao invés de comprar novo',
        xpReward: 150,
        difficulty: 'Fácil',
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 20)),
        completedAt: now.subtract(const Duration(days: 15)),
      ),
      Challenge(
        id: 'challenge_003',
        title: 'Reutilizar um objeto',
        description: 'Encontre uma nova função para um objeto antigo que você não usa mais',
        xpReward: 150,
        difficulty: 'Fácil',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      Challenge(
        id: 'challenge_004',
        title: 'Doar algo que não utiliza',
        description: 'Separe 5 itens que você não usa e doe para alguém que precise',
        xpReward: 200,
        difficulty: 'Médio',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }
}
