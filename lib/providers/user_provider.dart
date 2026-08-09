import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Provider que gerencia dados do usuário
class UserProvider extends ChangeNotifier {
  String _userId = '';
  String _userName = '';
  int _level = 1;
  int _xp = 0;
  
  // Getters
  String get userId => _userId;
  String get userName => _userName;
  int get level => _level;
  int get xp => _xp;

  UserProvider() {
    _initializeUser();
  }

  /// Inicializar usuário com ID único
  void _initializeUser() {
    _userId = const Uuid().v4();
    _userName = 'Usuário $level';
    notifyListeners();
  }

  /// Atualizar nome do usuário
  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  /// Adicionar XP ao usuário
  void addXp(int amount) {
    _xp += amount;
    // Aumentar nível a cada 1000 XP
    if (_xp >= 1000) {
      _level++;
      _xp = 0;
    }
    notifyListeners();
  }

  /// Resetar usuário
  void resetUser() {
    _userId = const Uuid().v4();
    _userName = '';
    _level = 1;
    _xp = 0;
    notifyListeners();
  }
}
