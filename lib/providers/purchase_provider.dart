import 'package:flutter/material.dart';
import 'package:consome_plus/models/purchase_model.dart';
import 'package:consome_plus/data/mock_data.dart';

/// Provider para gerenciar estado de compras
/// Responsável por:
/// - Manter histórico de compras
/// - Registrar novas compras
/// - Atualizar decisão final de compra
class PurchaseProvider extends ChangeNotifier {
  List<Purchase> _purchases = [];
  bool _isLoading = false;

  // Getters
  List<Purchase> get purchases => _purchases;
  bool get isLoading => _isLoading;

  /// Inicializa o provider
  PurchaseProvider() {
    _initializePurchases();
  }

  /// Carrega compras do armazenamento local
  Future<void> _initializePurchases() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implementar carregamento do Hive
      // Por enquanto, usando lista vazia
      await Future.delayed(const Duration(milliseconds: 300));
      _purchases = [];
    } catch (e) {
      print('Erro ao carregar compras: $e');
      _purchases = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adiciona nova compra ao histórico
  void addPurchase(Purchase purchase) {
    _purchases.insert(0, purchase); // Adiciona no início (mais recente)
    
    // TODO: Salvar no Hive
    notifyListeners();
  }

  /// Atualiza a decisão final de uma compra
  /// Se notBought = true, user não comprou
  /// Se notBought = false, user comprou mesmo assim
  void updatePurchaseDecision(
    String purchaseId,
    bool finalDecision,
  ) {
    final index = _purchases.indexWhere((p) => p.id == purchaseId);
    
    if (index != -1) {
      _purchases[index] = _purchases[index].copyWith(
        finalDecision: finalDecision,
        decidedAt: DateTime.now(),
      );
      
      // TODO: Salvar no Hive
      notifyListeners();
    }
  }

  /// Retorna compras não compradas (evitadas)
  List<Purchase> getPurchasesAvoided() {
    return _purchases.where((p) => p.finalDecision == false).toList();
  }

  /// Retorna compras realizadas
  List<Purchase> getPurchasesMade() {
    return _purchases.where((p) => p.finalDecision == true).toList();
  }

  /// Retorna compras por resultado
  List<Purchase> getPurchasesByResult(ConsciousPauseResult result) {
    return _purchases.where((p) => p.result == result).toList();
  }

  /// Calcula total economizado
  double getTotalMoneyPreserved() {
    double total = 0;
    for (var purchase in getPurchasesAvoided()) {
      total += purchase.price;
    }
    return total;
  }

  /// Calcula XP total ganho
  int getTotalXPEarned() {
    int total = 0;
    for (var purchase in _purchases) {
      if (purchase.finalDecision == false) {
        total += purchase.ecoXPEarned;
      }
    }
    return total;
  }

  /// Carrega compras mockadas (para teste)
  void loadMockPurchases(String userId) {
    _purchases = MockData.createMockPurchases(userId);
    notifyListeners();
  }

  /// Limpa todas as compras
  void clearPurchases() {
    _purchases.clear();
    notifyListeners();
  }
}
