import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method.dart';
import 'package:lumimoney_app/features/payment_methods/presentation/controllers/credit_card_invoices_controller.dart';
import 'package:lumimoney_app/features/payment_methods/presentation/controllers/payment_methods_controller.dart';
import 'package:lumimoney_app/features/transactions/domain/enums/transaction_enums.dart';
import 'package:lumimoney_app/features/transactions/domain/models/transaction_request.dart';
import 'package:lumimoney_app/features/transactions/presentation/controllers/transactions_controller.dart';
import 'package:lumimoney_app/shared/widgets/currency_text_field.dart';
import 'package:lumimoney_app/shared/widgets/payment_method_selector.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _installmentsController = TextEditingController();
  final _dateController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  TransactionFrequency _frequency = TransactionFrequency.unitary;
  TransactionStatus _status = TransactionStatus.pending;
  int _totalInstallments = 2;
  String? _selectedPaymentMethodId;
  String? _selectedInvoiceId;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _amountController.text = 'R\$ 0,00';
    _installmentsController.text = '2';
    _amountController.addListener(() {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentMethodsControllerProvider.notifier).getPaymentMethods();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _installmentsController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final selectedMethod = ref
        .read(paymentMethodsControllerProvider)
        .paymentMethods
        .firstWhere((method) => method.id == _selectedPaymentMethodId);
    final isCreditCard = selectedMethod.type == PaymentMethodType.creditCard;

    final request = TransactionRequest(
      description: _descriptionController.text,
      amount: double.parse(
        _amountController.text
            .replaceAll('R\$', '')
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .trim(),
      ),
      type: _type,
      frequency: _frequency,
      status: isCreditCard ? TransactionStatus.paid : _status,
      totalInstallments: _frequency == TransactionFrequency.installment
          ? _totalInstallments
          : null,
      paymentMethod: _selectedPaymentMethodId ?? '',
      creditCardInvoice: _selectedInvoiceId,
      date: DateFormat('dd/MM/yyyy').parse(_dateController.text),
    );

    ref
        .read(transactionsControllerProvider.notifier)
        .createTransaction(request)
        .then((_) {
      if (!mounted) return;

      final state = ref.read(transactionsControllerProvider);

      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(state.error!)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
        return;
      }

      // Atualiza a home
      ref.read(paymentMethodsControllerProvider.notifier).getPaymentMethods();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Transação cadastrada com sucesso!'),
              const Spacer(),
              TextButton(
                onPressed: () {
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Text(
                  'Voltar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
      Navigator.pop(context);
    });
  }

  void _showPaymentMethodSelector() {
    final paymentMethodsState = ref.watch(paymentMethodsControllerProvider);
    final paymentMethods = paymentMethodsState.paymentMethods;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Text(
                    'Selecione o Método de Pagamento',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: PaymentMethodSelector(
                  paymentMethods: paymentMethods,
                  selectedId: _selectedPaymentMethodId,
                  onSelect: _onPaymentMethodSelected,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPaymentMethodSelected(String id) {
    final paymentMethodsState = ref.read(paymentMethodsControllerProvider);
    setState(() {
      _selectedPaymentMethodId = id;
      _selectedInvoiceId = null;
    });
    Navigator.pop(context);

    final selectedMethod = paymentMethodsState.paymentMethods
        .firstWhere((method) => method.id == id);
    ref.read(creditCardInvoicesControllerProvider.notifier).clearState();

    if (selectedMethod.type == PaymentMethodType.creditCard) {
      ref.read(creditCardInvoicesControllerProvider.notifier).getInvoices(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionsState = ref.watch(transactionsControllerProvider);
    final paymentMethodsState = ref.watch(paymentMethodsControllerProvider);
    final invoicesState = ref.watch(creditCardInvoicesControllerProvider);
    final paymentMethods = paymentMethodsState.paymentMethods;

    // Seleciona o primeiro método de pagamento do tipo conta por padrão
    if (_selectedPaymentMethodId == null && paymentMethods.isNotEmpty) {
      final defaultMethod = paymentMethods.firstWhere(
        (method) => method.type == PaymentMethodType.account,
        orElse: () => paymentMethods.first,
      );
      _selectedPaymentMethodId = defaultMethod.id;
    }

    final selectedMethod = paymentMethods.firstWhere(
      (method) => method.id == _selectedPaymentMethodId,
      orElse: () => const PaymentMethod(
        id: '',
        name: 'Selecione um método de pagamento',
        type: PaymentMethodType.account,
      ),
    );

    final isCreditCard = selectedMethod.type == PaymentMethodType.creditCard;

    // Seleciona a primeira fatura com vencimento após a data atual
    if (isCreditCard &&
        invoicesState.invoices.isNotEmpty &&
        _selectedInvoiceId == null) {
      final now = DateTime.now();
      final futureInvoices = invoicesState.invoices.where(
        (invoice) => invoice.dueDate.isAfter(now) && !invoice.isClosed,
      );
      if (futureInvoices.isNotEmpty) {
        final nextInvoice = futureInvoices
            .reduce((a, b) => a.dueDate.isBefore(b.dueDate) ? a : b);
        _selectedInvoiceId = nextInvoice.id;
      } else {
        // Se não encontrar faturas futuras abertas, pega a mais recente que não esteja fechada
        final openInvoices =
            invoicesState.invoices.where((invoice) => !invoice.isClosed);
        if (openInvoices.isNotEmpty) {
          _selectedInvoiceId = openInvoices
              .reduce((a, b) => a.dueDate.isAfter(b.dueDate) ? a : b)
              .id;
        }
      }
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final maxWidth = isLargeScreen ? 1200.0 : 400.0;
    final crossAxisCount = isLargeScreen ? 2 : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Transação'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tipo de Transação
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tipo de Transação',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 8,
                            children: TransactionType.values.map((type) {
                              return RadioListTile<TransactionType>(
                                title: Text(type.label),
                                value: type,
                                groupValue: _type,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _type = value);
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descrição e Valor lado a lado em telas grandes
                  if (isLargeScreen)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Descrição',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira uma descrição';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CurrencyTextField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              labelText: 'Valor',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira um valor';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Descrição',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira uma descrição';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CurrencyTextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            labelText: 'Valor',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um valor';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Data e Método de Pagamento lado a lado em telas grandes
                  if (isLargeScreen)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _dateController,
                            decoration: const InputDecoration(
                              labelText: 'Data',
                              border: OutlineInputBorder(),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                _dateController.text =
                                    DateFormat('dd/MM/yyyy').format(date);
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, selecione uma data';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: _showPaymentMethodSelector,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Método de Pagamento',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(selectedMethod.name),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        TextFormField(
                          controller: _dateController,
                          decoration: const InputDecoration(
                            labelText: 'Data',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              _dateController.text =
                                  DateFormat('dd/MM/yyyy').format(date);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, selecione uma data';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: _showPaymentMethodSelector,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Método de Pagamento',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(selectedMethod.name),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Fatura do Cartão
                  if (isCreditCard)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (invoicesState.isLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else if (invoicesState.error != null)
                          Text(
                            'Erro ao carregar faturas: ${invoicesState.error}',
                            style: const TextStyle(color: Colors.red),
                          )
                        else if (invoicesState.invoices.isEmpty)
                          const Text(
                            'Nenhuma fatura disponível',
                            style: TextStyle(color: Colors.red),
                          )
                        else
                          DropdownButtonFormField<String>(
                            value: _selectedInvoiceId,
                            decoration: const InputDecoration(
                              labelText: 'Fatura',
                              border: OutlineInputBorder(),
                            ),
                            items: invoicesState.invoices.map((invoice) {
                              final dueDate = DateFormat('dd/MM/yyyy')
                                  .format(invoice.dueDate);
                              return DropdownMenuItem(
                                value: invoice.id,
                                child: Text(
                                  'Vencimento: $dueDate',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _selectedInvoiceId = value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, selecione uma fatura';
                              }
                              return null;
                            },
                          ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Status (não exibe se for cartão de crédito)
                  if (!isCreditCard)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 8,
                              children: TransactionStatus.values.map((status) {
                                return RadioListTile<TransactionStatus>(
                                  title: Text(status.label),
                                  value: status,
                                  groupValue: _status,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _status = value);
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Frequência
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Frequência',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 8,
                            children:
                                TransactionFrequency.values.map((frequency) {
                              return RadioListTile<TransactionFrequency>(
                                title: Text(frequency.label),
                                value: frequency,
                                groupValue: _frequency,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _frequency = value;
                                      if (value ==
                                          TransactionFrequency.unitary) {
                                        _totalInstallments = 1;
                                        _installmentsController.text = '1';
                                      } else if (value ==
                                              TransactionFrequency
                                                  .installment &&
                                          _totalInstallments < 2) {
                                        _totalInstallments = 2;
                                        _installmentsController.text = '2';
                                      }
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Parcelas
                  if (_frequency == TransactionFrequency.installment)
                    if (isLargeScreen)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _totalInstallments < 2
                                  ? 2
                                  : _totalInstallments,
                              decoration: const InputDecoration(
                                labelText: 'Número de Parcelas',
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(499, (index) => index + 2)
                                  .map(
                                    (number) => DropdownMenuItem(
                                      value: number,
                                      child: Text('$number parcelas'),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _totalInstallments = value;
                                    _installmentsController.text =
                                        value.toString();
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value < 2) {
                                  return 'Por favor, selecione o número de parcelas';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (_amountController.text.isNotEmpty &&
                              _amountController.text != 'R\$ 0,00')
                            Expanded(
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Valor da Parcela',
                                  border: OutlineInputBorder(),
                                ),
                                child: Builder(
                                  builder: (context) {
                                    final amount = double.parse(
                                      _amountController.text
                                          .replaceAll('R\$', '')
                                          .replaceAll('.', '')
                                          .replaceAll(',', '.')
                                          .trim(),
                                    );
                                    final installmentValue =
                                        amount / _totalInstallments;
                                    return Container(
                                      height: 24,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$_totalInstallments x ',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'R\$ ${installmentValue.toStringAsFixed(2).replaceAll('.', ',')}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          DropdownButtonFormField<int>(
                            value:
                                _totalInstallments < 2 ? 2 : _totalInstallments,
                            decoration: const InputDecoration(
                              labelText: 'Número de Parcelas',
                              border: OutlineInputBorder(),
                            ),
                            items: List.generate(499, (index) => index + 2)
                                .map(
                                  (number) => DropdownMenuItem(
                                    value: number,
                                    child: Text('$number parcelas'),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _totalInstallments = value;
                                  _installmentsController.text =
                                      value.toString();
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value < 2) {
                                return 'Por favor, selecione o número de parcelas';
                              }
                              return null;
                            },
                          ),
                          if (_amountController.text.isNotEmpty &&
                              _amountController.text != 'R\$ 0,00')
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$_totalInstallments x ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          final amount = double.parse(
                                            _amountController.text
                                                .replaceAll('R\$', '')
                                                .replaceAll('.', '')
                                                .replaceAll(',', '.')
                                                .trim(),
                                          );
                                          final installmentValue =
                                              amount / _totalInstallments;
                                          return Text(
                                            'R\$ ${installmentValue.toStringAsFixed(2).replaceAll('.', ',')}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                  const SizedBox(height: 24),

                  // Botão de Salvar
                  ElevatedButton(
                    onPressed: transactionsState.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: transactionsState.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Salvar'),
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
