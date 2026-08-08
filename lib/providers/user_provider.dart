import 'package:flutter/material.dart';
import 'package:consome_plus/models/user_model.dart';
import 'package:consome_plus/data/mock_data.dart';
import 'package:uuid/uuid.dart';

/// Provider para gerenciar estado do usuário
/// Responsável por:
/// - Criar/carregar usuário
/// - Atualizar dados do usuário
/// - Gerenciar nível e XP
class UserProvider extends ChangeNotifier {
  static const uuid = Uuid();
  
  User? _user;
  bool _isLoading = false;
  bool _isFirstTime = true;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isFirstTime => _isFirstTime;

  UserProvider() {
    _initializeUser();
  }

  /// Inicializa o usuário
  /// Verifica se existe usuário salvo, senão cria novo
  Future<void> _initializeUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implementar carregamento do Hive
      // Por enquanto, usando dados mockados
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Simulando que é primeira vez
      _user = null;
      _isFirstTime = true;
      
    } catch (e) {
      print('Erro ao inicializar usuário: $e');
      _user = null;
      _isFirstTime = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cria novo usuário
  Future<void> createUser(String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      _user = User(
        id: 'user_${uuid.v4().substring(0, 8)}',
        name: name,
        level: 1,
        totalEcoXP: 0,
        moneyPreserved: 0.0,
        purchasesAvoided: 0,
        productsRepaired: 0,
        productsReused: 0,
        productsDonated: 0,
        createdAt: now,
        updatedAt: now,
      );

      // TODO: Salvar no Hive
      // await _saveUserToStorage(_user!);

      _isFirstTime = false;
    } catch (e) {
      print('Erro ao criar usuário: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Atualiza XP do usuário
  /// Também atualiza nível se necessário
  void addEcoXP(int amount) {
    if (_user == null) return;

    _user = _user!.copyWith(
      totalEcoXP: _user!.totalEcoXP + amount,
      updatedAt: DateTime.now(),
    );

    // Verificar aumento de nível
    _checkLevelUp();
    
    // TODO: Salvar no Hive
    notifyListeners();
  }

  /// Verifica se usuário subiu de nível
  void _checkLevelUp() {
    if (_user == null) return;

    // XP necessário para cada nível
    const xpPerLevel = {
      1: 0,
      2: 500,
      3: 1200,
      4: 2000,
      5: 3500,
    };

    for (int level = 5; level > _user!.level; level--) {
      if (_user!.totalEcoXP >= xpPerLevel[level]!) {
        _user = _user!.copyWith(
          level: level,
          updatedAt: DateTime.now(),
        );
        // Aqui poderia mostrar uma notificação de level up
        print('🎉 Level Up! Agora você é nível $level');
        break;
      }
    }
  }

  /// Adiciona compras evitadas
  void addPurchaseAvoided() {
    if (_user == null) return;
    
    _user = _user!.copyWith(
      purchasesAvoided: _user!.purchasesAvoided + 1,
      updatedAt: DateTime.now(),
    );
    
    notifyListeners();
  }

  /// Adiciona dinheiro preservado
  void addMoneyPreserved(double amount) {
    if (_user == null) return;
    
    _user = _user!.copyWith(
      moneyPreserved: _user!.moneyPreserved + amount,
      updatedAt: DateTime.now(),
    );
    
    notifyListeners();
  }

  /// Adiciona produtos consertados
  void addProductRepaired() {
    if (_user == null) return;
    
    _user = _user!.copyWith(
      productsRepaired: _user!.productsRepaired + 1,
      updatedAt: DateTime.now(),
    );
    
    notifyListeners();
  }

  /// Adiciona produtos reutilizados
  void addProductReused() {
    if (_user == null) return;
    
    _user = _user!.copyWith(
      productsReused: _user!.productsReused + 1,
      updatedAt: DateTime.now(),
    );
    
    notifyListeners();
  }

  /// Adiciona produtos doados
  void addProductDonated() {
    if (_user == null) return;
    
    _user = _user!.copyWith(
      productsDonated: _user!.productsDonated + 1,
      updatedAt: DateTime.now(),
    );
    
    notifyListeners();
  }

  /// Carrega usuário de dados mockados (para teste)
  void loadMockUser() {
    _user = MockData.createMockUser();
    _isFirstTime = false;
    notifyListeners();
  }
}
