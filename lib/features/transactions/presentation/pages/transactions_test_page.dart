import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumimoney_app/features/transactions/domain/enums/transaction_enums.dart';
import 'package:lumimoney_app/features/transactions/presentation/controllers/transactions_list_controller.dart';

class TransactionsTestPage extends ConsumerStatefulWidget {
  const TransactionsTestPage({super.key});

  @override
  ConsumerState<TransactionsTestPage> createState() =>
      _TransactionsTestPageState();
}

class _TransactionsTestPageState extends ConsumerState<TransactionsTestPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionsListControllerProvider.notifier).getTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionsListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Transações'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Text(
                    'Erro ao carregar transações: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = state.transactions[index];
                    final date =
                        DateFormat('dd/MM/yyyy').format(transaction.date);
                    final amount = NumberFormat.currency(
                      locale: 'pt_BR',
                      symbol: 'R\$',
                      decimalDigits: 2,
                    ).format(transaction.amount);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  transaction.type == TransactionType.income
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color:
                                      transaction.type == TransactionType.income
                                          ? Colors.green
                                          : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    transaction.description,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  amount,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: transaction.type ==
                                            TransactionType.income
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  date,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  transaction.paymentMethod?.name ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                if (transaction.frequency ==
                                    TransactionFrequency.installment) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '${transaction.installmentNumber}/${transaction.totalInstallments}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: transaction.status ==
                                            TransactionStatus.paid
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    transaction.status.label,
                                    style: TextStyle(
                                      color: transaction.status ==
                                              TransactionStatus.paid
                                          ? Colors.green
                                          : Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
