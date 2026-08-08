/// Enum para resultado da Pausa Consciente
enum ConsciousPauseResult {
  conscientious,  // 🟢 Compra Consciente
  thinkBetter,    // 🟡 Pense Melhor
  unnecessary;    // 🔴 Consumo Desnecessário

  /// Retorna o emoji correspondente
  String get emoji {
    switch (this) {
      case ConsciousPauseResult.conscientious:
        return '🟢';
      case ConsciousPauseResult.thinkBetter:
        return '🟡';
      case ConsciousPauseResult.unnecessary:
        return '🔴';
    }
  }

  /// Retorna o texto em português
  String get label {
    switch (this) {
      case ConsciousPauseResult.conscientious:
        return 'Compra Consciente';
      case ConsciousPauseResult.thinkBetter:
        return 'Pense Melhor';
      case ConsciousPauseResult.unnecessary:
        return 'Consumo Desnecessário';
    }
  }

  /// Retorna a descrição
  String get description {
    switch (this) {
      case ConsciousPauseResult.conscientious:
        return 'Você fez uma boa reflexão! Se decidir comprar, será uma compra consciente.';
      case ConsciousPauseResult.thinkBetter:
        return 'Existe a possibilidade de encontrar alternativas melhores. Pense mais!';
      case ConsciousPauseResult.unnecessary:
        return 'Esta compra pode ser desnecessária. Considere as alternativas!';
    }
  }
}

/// Modelo de Compra/Análise de Consumo
/// Registra uma análise de compra através da Pausa Consciente
class Purchase {
  final String id;
  final String userId;
  final String productName;
  final double price;
  final String category;
  final DateTime analyzedAt;
  
  // Respostas do questionário
  final Map<String, bool> answers; // {id_pergunta: resposta}
  
  // Resultado
  final ConsciousPauseResult result;
  final int ecoXPEarned;
  
  // Decisão final do usuário
  final bool? finalDecision; // true = comprou, false = não comprou, null = ainda não decidiu
  final DateTime? decidedAt;

  Purchase({
    required this.id,
    required this.userId,
    required this.productName,
    required this.price,
    required this.category,
    required this.analyzedAt,
    required this.answers,
    required this.result,
    required this.ecoXPEarned,
    this.finalDecision,
    this.decidedAt,
  });

  /// Converte para Map (para armazenamento)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productName': productName,
      'price': price,
      'category': category,
      'analyzedAt': analyzedAt.toIso8601String(),
      'answers': answers,
      'result': result.toString(),
      'ecoXPEarned': ecoXPEarned,
      'finalDecision': finalDecision,
      'decidedAt': decidedAt?.toIso8601String(),
    };
  }

  /// Cria um Purchase a partir de um Map
  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'] as String,
      userId: map['userId'] as String,
      productName: map['productName'] as String,
      price: (map['price'] as num).toDouble(),
      category: map['category'] as String,
      analyzedAt: DateTime.parse(map['analyzedAt'] as String),
      answers: Map<String, bool>.from(map['answers'] as Map),
      result: ConsciousPauseResult.values.firstWhere(
        (e) => e.toString() == map['result'],
      ),
      ecoXPEarned: map['ecoXPEarned'] as int,
      finalDecision: map['finalDecision'] as bool?,
      decidedAt: map['decidedAt'] != null
          ? DateTime.parse(map['decidedAt'] as String)
          : null,
    );
  }

  /// Cria uma cópia com alguns campos modificados
  Purchase copyWith({
    String? id,
    String? userId,
    String? productName,
    double? price,
    String? category,
    DateTime? analyzedAt,
    Map<String, bool>? answers,
    ConsciousPauseResult? result,
    int? ecoXPEarned,
    bool? finalDecision,
    DateTime? decidedAt,
  }) {
    return Purchase(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      category: category ?? this.category,
      analyzedAt: analyzedAt ?? this.analyzedAt,
      answers: answers ?? this.answers,
      result: result ?? this.result,
      ecoXPEarned: ecoXPEarned ?? this.ecoXPEarned,
      finalDecision: finalDecision ?? this.finalDecision,
      decidedAt: decidedAt ?? this.decidedAt,
    );
  }

  @override
  String toString() {
    return 'Purchase(id: $id, productName: $productName, price: $price, '
        'result: ${result.label})';
  }
}
