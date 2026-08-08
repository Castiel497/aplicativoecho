import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/config/theme.dart';
import 'package:consome_plus/utils/validators.dart';
import 'package:consome_plus/utils/constants.dart';
import 'package:consome_plus/services/purchase_service.dart';

/// Tela para registrar uma nova compra
/// Coleta: nome do produto, preço e categoria
class NewPurchaseScreen extends StatefulWidget {
  const NewPurchaseScreen({Key? key}) : super(key: key);

  @override
  State<NewPurchaseScreen> createState() => _NewPurchaseScreenState();
}

class _NewPurchaseScreenState extends State<NewPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedCategory;
  bool _isLoading = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  /// Continua para Pausa Consciente
  Future<void> _continueToConsciousPause() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final productName = _productNameController.text.trim();
      final price = AppValidators.convertPrice(_priceController.text)!;
      final category = _selectedCategory!;

      // Passar dados para próxima tela via Navigator
      if (mounted) {
        Navigator.of(context).pushNamed(
          '/conscious-pause',
          arguments: {
            'productName': productName,
            'price': price,
            'category': category,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Compra'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              Text(
                'Qual produto você deseja comprar?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 24),

              // Nome do produto
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Produto',
                  hintText: 'Ex: Fone de Ouvido',
                  prefixIcon: const Icon(Icons.shopping_bag_outlined),
                  filled: true,
                  fillColor: AppColors.white,
                ),
                validator: AppValidators.validateProductName,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Preço
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Preço (R$)',
                  hintText: 'Ex: 150,00',
                  prefixIcon: const Icon(Icons.attach_money),
                  filled: true,
                  fillColor: AppColors.white,
                ),
                validator: AppValidators.validatePrice,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Categoria
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  prefixIcon: const Icon(Icons.category_outlined),
                  filled: true,
                  fillColor: AppColors.white,
                ),
                items: AppConstants.productCategories
                    .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) => AppValidators.validateCategory(value),
              ),
              const SizedBox(height: 32),

              // Informação
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '💭 Após preencher, você responderá 6 perguntas para fazer uma reflexão consciente sobre essa compra.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botão Continuar
              ElevatedButton(
                onPressed: _isLoading ? null : _continueToConsciousPause,
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : const Text('Continuar para Pausa Consciente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
