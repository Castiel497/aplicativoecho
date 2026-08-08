import 'package:consome_plus/models/purchase_model.dart';
import 'package:uuid/uuid.dart';

/// Serviço de gerenciamento de compras
/// Responsável por lógica de análise da Pausa Consciente
class PurchaseService {
  static const uuid = Uuid();

  /// Calcula o resultado da Pausa Consciente baseado nas respostas
  /// 
  /// A lógica funciona assim:
  /// - Cada resposta "correta" (que evita compra) ganha pontos
  /// - Quanto mais pontos, mais consciente é a compra
  static ConsciousPauseResult calculateResult(Map<String, bool> answers) {
    int greenPoints = 0;

    // Lógica de pontuação
    // NÃO precisa (false) = bom
    if (answers['needsIt'] == false) greenPoints += 2;
    
    // NÃO tem parecido (false) = bom
    if (answers['alreadyHas'] == false) greenPoints += 1;
    
    // Produto ainda funciona (true) = bom, não precisa comprar novo
    if (answers['currentWorks'] == true) greenPoints += 2;
    
    // Pode consertar (true) = ótimo, não precisa comprar novo
    if (answers['canRepair'] == true) greenPoints += 3;
    
    // Pode reutilizar (true) = bom, não precisa comprar novo
    if (answers['canReuse'] == true) greenPoints += 2;
    
    // Pode comprar usado (true) = bom, é uma alternativa sustentável
    if (answers['canBuyUsed'] == true) greenPoints += 2;

    // Classificação final
    if (greenPoints >= 7) {
      return ConsciousPauseResult.conscientious; // 🟢
    } else if (greenPoints >= 4) {
      return ConsciousPauseResult.thinkBetter; // 🟡
    } else {
      return ConsciousPauseResult.unnecessary; // 🔴
    }
  }

  /// Calcula os pontos XP ganhos com base no resultado
  static int calculateXP(ConsciousPauseResult result, {bool notBought = false}) {
    // Se o usuário não comprou, ganha XP extra
    if (notBought) {
      switch (result) {
        case ConsciousPauseResult.conscientious:
          return 150; // Compra consciente e não comprou = 150 XP
        case ConsciousPauseResult.thinkBetter:
          return 100; // Pensou melhor e não comprou = 100 XP
        case ConsciousPauseResult.unnecessary:
          return 100; // Identificou consumo desnecessário = 100 XP
      }
    }
    
    // Se comprou mesmo assim
    return 0; // Sem XP se ignorou a análise
  }

  /// Gera um ID único para a compra
  static String generatePurchaseId() {
    return 'purchase_${uuid.v4().substring(0, 8)}';
  }

  /// Cria uma nova compra
  static Purchase createPurchase({
    required String userId,
    required String productName,
    required double price,
    required String category,
    required Map<String, bool> answers,
  }) {
    final now = DateTime.now();
    final result = calculateResult(answers);
    final xpEarned = calculateXP(result);

    return Purchase(
      id: generatePurchaseId(),
      userId: userId,
      productName: productName,
      price: price,
      category: category,
      analyzedAt: now,
      answers: answers,
      result: result,
      ecoXPEarned: xpEarned,
    );
  }

  /// Obtém sugestões de alternativas baseado no resultado
  static List<String> getAlternativeSuggestions(
    ConsciousPauseResult result,
    Map<String, bool> answers,
  ) {
    final suggestions = <String>[];

    // Sugestões baseadas nas respostas
    if (answers['currentWorks'] == true) {
      suggestions.add('✓ Seu produto atual ainda funciona! Considere usá-lo por mais tempo.');
    }

    if (answers['canRepair'] == true) {
      suggestions.add('✓ Você pode consertar o produto atual. É uma alternativa sustentável!');
    }

    if (answers['canReuse'] == true) {
      suggestions.add('✓ Reutilize algo que já possui. É criativo e eco-friendly!');
    }

    if (answers['canBuyUsed'] == true) {
      suggestions.add('✓ Considere comprar usado. Você economiza e ajuda o planeta!');
    }

    if (answers['alreadyHas'] == true && answers['needsIt'] == true) {
      suggestions.add('⚠️ Você já possui algo parecido. Tem certeza que precisa de outro?');
    }

    if (suggestions.isEmpty) {
      suggestions.add('💭 Reflita mais sobre essa compra antes de decidir.');
    }

    return suggestions;
  }

  /// Calcula o impacto financeiro (quanto economizou/gastou)
  static double calculateFinancialImpact(
    double price,
    bool notBought,
  ) {
    return notBought ? price : 0.0;
  }
}
