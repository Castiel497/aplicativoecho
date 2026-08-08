/// Modelo do Usuário
/// Representa os dados do usuário no CONSOME+
class User {
  final String id;
  final String name;
  int level;                    // Nível (1-5)
  int totalEcoXP;              // XP total acumulado
  double moneyPreserved;       // Dinheiro economizado em R$
  int purchasesAvoided;        // Compras evitadas
  int productsRepaired;        // Produtos consertados
  int productsReused;          // Produtos reutilizados
  int productsDonated;         // Produtos doados
  final DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    this.level = 1,
    this.totalEcoXP = 0,
    this.moneyPreserved = 0.0,
    this.purchasesAvoided = 0,
    this.productsRepaired = 0,
    this.productsReused = 0,
    this.productsDonated = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Converte para Map (para armazenamento)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'totalEcoXP': totalEcoXP,
      'moneyPreserved': moneyPreserved,
      'purchasesAvoided': purchasesAvoided,
      'productsRepaired': productsRepaired,
      'productsReused': productsReused,
      'productsDonated': productsDonated,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Cria um User a partir de um Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      level: map['level'] as int? ?? 1,
      totalEcoXP: map['totalEcoXP'] as int? ?? 0,
      moneyPreserved: (map['moneyPreserved'] as num?)?.toDouble() ?? 0.0,
      purchasesAvoided: map['purchasesAvoided'] as int? ?? 0,
      productsRepaired: map['productsRepaired'] as int? ?? 0,
      productsReused: map['productsReused'] as int? ?? 0,
      productsDonated: map['productsDonated'] as int? ?? 0,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  /// Cria uma cópia com alguns campos modificados
  User copyWith({
    String? id,
    String? name,
    int? level,
    int? totalEcoXP,
    double? moneyPreserved,
    int? purchasesAvoided,
    int? productsRepaired,
    int? productsReused,
    int? productsDonated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      totalEcoXP: totalEcoXP ?? this.totalEcoXP,
      moneyPreserved: moneyPreserved ?? this.moneyPreserved,
      purchasesAvoided: purchasesAvoided ?? this.purchasesAvoided,
      productsRepaired: productsRepaired ?? this.productsRepaired,
      productsReused: productsReused ?? this.productsReused,
      productsDonated: productsDonated ?? this.productsDonated,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, level: $level, ecoXP: $totalEcoXP, '
        'moneyPreserved: $moneyPreserved)';
  }
}
