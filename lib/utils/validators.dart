/// Validadores para formulários do CONSOME+
class AppValidators {
  /// Valida nome do usuário
  /// Deve ter entre 2 e 50 caracteres
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu nome';
    }
    if (value.length < 2) {
      return 'O nome deve ter no mínimo 2 caracteres';
    }
    if (value.length > 50) {
      return 'O nome deve ter no máximo 50 caracteres';
    }
    return null;
  }

  /// Valida nome do produto
  /// Deve ter entre 3 e 100 caracteres
  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o nome do produto';
    }
    if (value.length < 3) {
      return 'O nome do produto deve ter no mínimo 3 caracteres';
    }
    if (value.length > 100) {
      return 'O nome do produto deve ter no máximo 100 caracteres';
    }
    return null;
  }

  /// Valida preço
  /// Deve ser um número positivo
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o preço';
    }
    
    // Tenta converter para double
    final price = double.tryParse(value.replaceAll(',', '.'));
    
    if (price == null) {
      return 'Por favor, insira um valor válido';
    }
    
    if (price <= 0) {
      return 'O preço deve ser maior que zero';
    }
    
    if (price > 999999) {
      return 'O preço não pode ser maior que R$ 999.999,00';
    }
    
    return null;
  }

  /// Valida categoria
  static String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, selecione uma categoria';
    }
    return null;
  }

  /// Converte string de preço para double
  /// Aceita formatos: "100", "100.50", "100,50"
  static double? convertPrice(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    final normalized = value.replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  /// Valida se a string é um email válido
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um email';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }
    
    return null;
  }

  /// Valida se a string é uma senha segura
  /// Deve ter pelo menos 6 caracteres, uma letra e um número
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma senha';
    }

    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }

    if (!value.contains(RegExp(r'[A-Za-z]'))) {
      return 'A senha deve conter pelo menos uma letra';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'A senha deve conter pelo menos um número';
    }

    return null;
  }

  /// Valida se dois valores são iguais (para confirmação de senha)
  static String? validateMatch(String? value, String? other) {
    if (value != other) {
      return 'Os valores não correspondem';
    }
    return null;
  }
}
