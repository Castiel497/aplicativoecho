/// CONSTANTES DO APLICATIVO CONSOME+

class AppConstants {
  // Strings
  static const String appName = 'CONSOME+';
  static const String appSlogan = 'Pense antes de comprar.';
  
  // Durações
  static const Duration splashDuration = Duration(seconds: 2);
  
  // Valores padrão
  static const int initialLevel = 1;
  static const int initialEcoXP = 0;
  static const double initialMoneyPreserved = 0.0;
  
  // Níveis
  static const Map<int, String> levels = {
    1: 'Consumidor Iniciante',
    2: 'Consumidor Consciente',
    3: 'Consumidor Sustentável',
    4: 'Guardião do Consumo',
    5: 'ECO MASTER',
  };
  
  // XP necessário por nível
  static const Map<int, int> xpPerLevel = {
    1: 0,      // Nível 1: começa com 0 XP
    2: 500,    // Nível 2: 500 XP
    3: 1200,   // Nível 3: 1200 XP
    4: 2000,   // Nível 4: 2000 XP
    5: 3500,   // Nível 5: 3500 XP (MASTER)
  };
  
  // Categorias de produtos
  static const List<String> productCategories = [
    'Eletrônicos',
    'Roupas',
    'Alimentos',
    'Casa',
    'Saúde',
    'Beleza',
    'Esportes',
    'Diversão',
    'Outros',
  ];
  
  // XP por ação
  static const Map<String, int> xpRewards = {
    'avoidPurchase': 100,      // Evitar compra desnecessária
    'repairProduct': 150,      // Consertar um produto
    'buyUsed': 200,            // Comprar usado
    'reuseProduct': 150,       // Reutilizar
    'donateProduct': 200,      // Doar
  };
  
  // Perguntas da Pausa Consciente
  static const List<Map<String, String>> consciousPauseQuestions = [
    {
      'id': 'needsIt',
      'question': 'Você realmente precisa desse produto?',
      'yes': 'Sim, preciso',
      'no': 'Não, acho que não',
    },
    {
      'id': 'alreadyHas',
      'question': 'Você já possui algo parecido?',
      'yes': 'Sim, tenho',
      'no': 'Não, não tenho',
    },
    {
      'id': 'currentWorks',
      'question': 'O produto que você possui ainda funciona?',
      'yes': 'Sim, funciona',
      'no': 'Não, está quebrado',
    },
    {
      'id': 'canRepair',
      'question': 'É possível consertar o produto atual?',
      'yes': 'Sim, posso consertar',
      'no': 'Não, não consigo',
    },
    {
      'id': 'canReuse',
      'question': 'É possível reutilizar algo que você já possui?',
      'yes': 'Sim, posso reutilizar',
      'no': 'Não, não é possível',
    },
    {
      'id': 'canBuyUsed',
      'question': 'Existe a possibilidade de comprar usado?',
      'yes': 'Sim, posso comprar usado',
      'no': 'Não, preciso novo',
    },
  ];
  
  // Desafios iniciais
  static const List<Map<String, dynamic>> initialChallenges = [
    {
      'id': 1,
      'title': 'Ficar 7 dias sem compras por impulso',
      'description': 'Resista à tentação e não faça compras por impulso durante 7 dias',
      'xpReward': 300,
      'difficulty': 'Médio',
    },
    {
      'id': 2,
      'title': 'Consertar algo antes de comprar outro',
      'description': 'Encontre algo quebrado em casa e conserte-o ao invés de comprar novo',
      'xpReward': 150,
      'difficulty': 'Fácil',
    },
    {
      'id': 3,
      'title': 'Reutilizar um objeto',
      'description': 'Encontre uma nova função para um objeto antigo que você não usa mais',
      'xpReward': 150,
      'difficulty': 'Fácil',
    },
    {
      'id': 4,
      'title': 'Doar algo que não utiliza',
      'description': 'Separe 5 itens que você não usa e doe para alguém que precise',
      'xpReward': 200,
      'difficulty': 'Médio',
    },
  ];
}
