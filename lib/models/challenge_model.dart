/// Modelo de Desafio
/// Representa um desafio que o usuário pode completar
class Challenge {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final String difficulty;  // Fácil, Médio, Difícil
  bool isCompleted;
  final DateTime createdAt;
  DateTime? completedAt;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.difficulty,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });

  /// Converte para Map (para armazenamento)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'xpReward': xpReward,
      'difficulty': difficulty,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// Cria um Challenge a partir de um Map
  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      xpReward: map['xpReward'] as int,
      difficulty: map['difficulty'] as String,
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
    );
  }

  /// Cria uma cópia com alguns campos modificados
  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    int? xpReward,
    String? difficulty,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      xpReward: xpReward ?? this.xpReward,
      difficulty: difficulty ?? this.difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Retorna a cor da dificuldade
  String getDifficultyColor() {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
        return '🟢';
      case 'médio':
        return '🟡';
      case 'difícil':
        return '🔴';
      default:
        return '⚪';
    }
  }

  @override
  String toString() {
    return 'Challenge(id: $id, title: $title, difficulty: $difficulty)';
  }
}
