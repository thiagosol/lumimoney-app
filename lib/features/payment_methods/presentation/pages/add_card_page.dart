import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumimoney_app/features/payment_methods/presentation/controllers/payment_methods_controller.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddCardPage extends ConsumerStatefulWidget {
  const AddCardPage({super.key});

  @override
  ConsumerState<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends ConsumerState<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _limitController = TextEditingController(text: '0,00');
  final _dueDayController = TextEditingController();
  final _closingDayController = TextEditingController();
  
  final _dayMask = MaskTextInputFormatter(
    mask: '##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    _dueDayController.dispose();
    _closingDayController.dispose();
    super.dispose();
  }

  String _getLimitValue() {
    final value = _limitController.text
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return value;
  }

  void _formatMoney(String value) {
    if (value.isEmpty) {
      _limitController.text = '0,00';
      _limitController.selection = TextSelection.fromPosition(
        TextPosition(offset: _limitController.text.length),
      );
      return;
    }

    // Remove todos os caracteres não numéricos
    final numbers = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Se não tiver números, mantém 0,00
    if (numbers.isEmpty) {
      _limitController.text = '0,00';
      _limitController.selection = TextSelection.fromPosition(
        TextPosition(offset: _limitController.text.length),
      );
      return;
    }

    // Converte para inteiro
    final amount = int.parse(numbers);
    
    // Formata o valor
    final formatted = (amount / 100).toStringAsFixed(2);
    final parts = formatted.split('.');
    
    // Adiciona os pontos para milhares
    final wholePart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    
    final newText = '$wholePart,${parts[1]}';
    _limitController.text = newText;
    _limitController.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentMethodsState = ref.watch(paymentMethodsControllerProvider);
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Cartão'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: isWeb ? const BoxConstraints(maxWidth: 400) : null,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Cartão',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do cartão';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _limitController,
                    decoration: const InputDecoration(
                      labelText: 'Limite do Cartão',
                      border: OutlineInputBorder(),
                      prefixText: 'R\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: _formatMoney,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o limite do cartão';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dueDayController,
                    decoration: const InputDecoration(
                      labelText: 'Dia de Vencimento (1-31)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [_dayMask],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o dia de vencimento';
                      }
                      final day = int.tryParse(value);
                      if (day == null || day < 1 || day > 31) {
                        return 'O dia deve estar entre 1 e 31';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _closingDayController,
                    decoration: const InputDecoration(
                      labelText: 'Dia de Fechamento (1-31)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [_dayMask],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o dia de fechamento';
                      }
                      final day = int.tryParse(value);
                      if (day == null || day < 1 || day > 31) {
                        return 'O dia deve estar entre 1 e 31';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: paymentMethodsState.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await ref
                                    .read(paymentMethodsControllerProvider.notifier)
                                    .addCard(
                                      _nameController.text,
                                      double.parse(_getLimitValue()),
                                      int.parse(_dueDayController.text),
                                      int.parse(_closingDayController.text),
                                    );
                                if (mounted) {
                                  await ref
                                      .read(paymentMethodsControllerProvider.notifier)
                                      .getPaymentMethods();
                                  if (mounted) {
                                    context.pop();
                                  }
                                }
                              }
                            },
                      child: paymentMethodsState.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Adicionar Cartão'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 