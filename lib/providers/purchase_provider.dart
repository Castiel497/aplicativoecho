import 'package:flutter/foundation.dart';

/// Modelo de compra
class Purchase {
  final String id;
  final String title;
  final double price;
  final DateTime date;
  final String category;
  final bool isPaused;

  Purchase({
    required this.id,
    required this.title,
    required this.price,
    required this.date,
    required this.category,
    this.isPaused = false,
  });
}

/// Provider que gerencia histórico de compras
class PurchaseProvider extends ChangeNotifier {
  final List<Purchase> _purchases = [];

  List<Purchase> get purchases => _purchases;

  /// Adicionar nova compra
  void addPurchase(Purchase purchase) {
    _purchases.add(purchase);
    notifyListeners();
  }

  /// Remover compra
  void removePurchase(String purchaseId) {
    _purchases.removeWhere((p) => p.id == purchaseId);
    notifyListeners();
  }

  /// Pausar compra (pausa consciente)
  void pausePurchase(String purchaseId) {
    final index = _purchases.indexWhere((p) => p.id == purchaseId);
    if (index != -1) {
      _purchases[index] = Purchase(
        id: _purchases[index].id,
        title: _purchases[index].title,
        price: _purchases[index].price,
        date: _purchases[index].date,
        category: _purchases[index].category,
        isPaused: !_purchases[index].isPaused,
      );
      notifyListeners();
    }
  }

  /// Total gasto
  double get totalSpent {
    return _purchases.fold(0, (sum, p) => sum + p.price);
  }

  /// Quantidade de compras
  int get purchaseCount => _purchases.length;
}
