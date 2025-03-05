import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumimoney_app/core/utils/money_formatter.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method_request.dart';
import 'package:lumimoney_app/features/payment_methods/presentation/controllers/payment_methods_controller.dart';
import 'package:lumimoney_app/shared/widgets/money_text_field.dart';

class AddAccountPage extends ConsumerStatefulWidget {
  const AddAccountPage({super.key});

  @override
  ConsumerState<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends ConsumerState<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentMethodsState = ref.watch(paymentMethodsControllerProvider);
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Conta'),
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
                      labelText: 'Nome da Conta',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome da conta';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  MoneyTextField(
                    controller: _balanceController,
                    label: 'Saldo Inicial',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o saldo inicial';
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
                                    .addAccount(
                                      _nameController.text,
                                      MoneyFormatter.parse(_balanceController.text),
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
                          : const Text('Adicionar Conta'),
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