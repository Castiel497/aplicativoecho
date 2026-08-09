import 'package:flutter/foundation.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/providers/purchase_provider.dart';

/// Provider que calcula estatísticas do usuário
class StatsProvider extends ChangeNotifier {
  
  StatsProvider();

  /// Calcular total economizado (exemplo: com pausa consciente)
  double calculateEconomized(UserProvider userProvider, PurchaseProvider purchaseProvider) {
    final pausedCount = purchaseProvider.purchases.where((p) => p.isPaused).length;
    return pausedCount * 50.0; // Estimativa de economia por compra pausada
  }

  /// Categoria com maior gasto
  String getTopCategory(PurchaseProvider purchaseProvider) {
    if (purchaseProvider.purchases.isEmpty) return 'N/A';
    
    final categories = <String, double>{};
    for (var purchase in purchaseProvider.purchases) {
      categories[purchase.category] = (categories[purchase.category] ?? 0) + purchase.price;
    }
    
    return categories.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Média de compras por dia
  double getAveragePurchasesPerDay(PurchaseProvider purchaseProvider) {
    if (purchaseProvider.purchases.isEmpty) return 0;
    
    final now = DateTime.now();
    final firstPurchase = purchaseProvider.purchases.first.date;
    final days = now.difference(firstPurchase).inDays + 1;
    
    return purchaseProvider.purchaseCount / days;
  }
}
