import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method_request.dart';
import 'package:lumimoney_app/features/payment_methods/presentation/controllers/payment_methods_controller.dart';

class AddCardPage extends ConsumerStatefulWidget {
  const AddCardPage({super.key});

  @override
  ConsumerState<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends ConsumerState<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dueDayController = TextEditingController();
  final _closingDayController = TextEditingController();
  final _limitController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dueDayController.dispose();
    _closingDayController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = CreditCardRequest(
      name: _nameController.text,
      dueDayOfMonth: int.parse(_dueDayController.text),
      closingDayOfMonth: int.parse(_closingDayController.text),
      creditLimit: double.parse(_limitController.text),
    );

    await ref.read(paymentMethodsControllerProvider.notifier).createPaymentMethod(request);
    
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentMethodsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Cartão'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
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
              controller: _dueDayController,
              decoration: const InputDecoration(
                labelText: 'Dia do Vencimento',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o dia do vencimento';
                }
                final number = int.tryParse(value);
                if (number == null || number < 1 || number > 31) {
                  return 'Por favor, insira um dia válido (1-31)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _closingDayController,
              decoration: const InputDecoration(
                labelText: 'Dia do Fechamento',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o dia do fechamento';
                }
                final number = int.tryParse(value);
                if (number == null || number < 1 || number > 31) {
                  return 'Por favor, insira um dia válido (1-31)';
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
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o limite do cartão';
                }
                final number = double.tryParse(value);
                if (number == null || number <= 0) {
                  return 'Por favor, insira um valor válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: state.isLoading ? null : _submit,
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Criar Cartão'),
            ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  state.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 