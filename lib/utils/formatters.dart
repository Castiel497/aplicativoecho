import 'package:intl/intl.dart';

/// Utilitários de formatação para o CONSOME+
class AppFormatters {
  /// Formata um valor em Real (R$)
  /// Exemplo: 150.50 → "R$ 150,50"
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  /// Formata um valor em Real sem símbolo
  /// Exemplo: 150.50 → "150,50"
  static String formatCurrencyValue(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
      decimalDigits: 2,
    );
    return formatter.format(value).trim();
  }

  /// Formata uma data para exibição
  /// Exemplo: 2024-01-15 → "15 de jan de 2024"
  static String formatDate(DateTime date) {
    final formatter = DateFormat('d \'de\' MMMM \'de\' yyyy', 'pt_BR');
    return formatter.format(date);
  }

  /// Formata uma data de forma curta
  /// Exemplo: 2024-01-15 → "15/01/2024"
  static String formatDateShort(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy', 'pt_BR');
    return formatter.format(date);
  }

  /// Formata uma data e hora
  /// Exemplo: 2024-01-15 10:30 → "15/01/2024 10:30"
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');
    return formatter.format(dateTime);
  }

  /// Formata o tempo relativo até agora
  /// Exemplo: 2 horas atrás, 3 dias atrás, etc
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Agora mesmo';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'Há $minutes minuto${minutes > 1 ? 's' : ''}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'Há $hours hora${hours > 1 ? 's' : ''}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'Há $days dia${days > 1 ? 's' : ''}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Há $weeks semana${weeks > 1 ? 's' : ''}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Há $months mês${months > 1 ? 'es' : ''}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Há $years ano${years > 1 ? 's' : ''}';
    }
  }

  /// Formata um número com separador de milhar
  /// Exemplo: 1500 → "1.500"
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,###', 'pt_BR');
    return formatter.format(number);
  }

  /// Formata XP para exibição
  /// Exemplo: 1500 → "+1.500 XP"
  static String formatXP(int xp, {bool showPlus = true}) {
    final formatted = formatNumber(xp);
    return '${showPlus && xp > 0 ? '+' : ''}$formatted XP';
  }

  /// Capitaliza a primeira letra
  /// Exemplo: "hello" → "Hello"
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Formata um nome próprio (cada palavra com primeira letra maiúscula)
  /// Exemplo: "joão silva" → "João Silva"
  static String formatName(String text) {
    return text
        .split(' ')
        .map((word) => capitalize(word.toLowerCase()))
        .join(' ');
  }

  /// Formata categoria com primeira letra maiúscula
  static String formatCategory(String category) {
    return capitalize(category.toLowerCase());
  }
}
