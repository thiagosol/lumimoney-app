import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method.dart';
import 'package:lumimoney_app/features/transactions/domain/enums/transaction_enums.dart';
import 'package:lumimoney_app/features/transactions/presentation/controllers/transactions_controller.dart';
import 'package:lumimoney_app/shared/constants/app_constants.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  final String? type;
  final String? id;

  const TransactionsPage({
    super.key,
    this.type,
    this.id,
  });

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<DateTime> _months;
  late int _initialIndex;

  @override
  void initState() {
    super.initState();

    // Gera lista de meses (6 meses para trás e 12 para frente)
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    _months = List.generate(19,
        (index) => DateTime(currentMonth.year, currentMonth.month - 6 + index));

    // Define o índice inicial como o mês atual (índice 6)
    _initialIndex = 6;

    _tabController = TabController(
      length: _months.length,
      vsync: this,
      initialIndex: _initialIndex,
    );

    // Carrega as transações do mês atual
    _loadTransactions(_months[_initialIndex]);

    // Adiciona listener para carregar transações quando mudar de aba
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadTransactions(_months[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadTransactions(DateTime month) {
    final yearMonth = DateFormat('yyyy-MM').format(month);
    ref.read(transactionsControllerProvider.notifier).getTransactionsByMonth(
          yearMonth,
          widget.type,
          widget.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionsControllerProvider);
    final monthFormat = DateFormat('MMM yyyy', 'pt_BR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _months
              .map((month) => Tab(
                    text: monthFormat.format(month).toUpperCase(),
                  ))
              .toList(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadTransactions(_months[_tabController.index]);
        },
        child: TabBarView(
          controller: _tabController,
          children: _months.map((month) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(
                child: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final transactions = state.transactions;
            if (transactions.isEmpty) {
              return const Center(
                child: Text('Nenhuma transação encontrada'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final currencyFormat = NumberFormat.currency(
                  locale: 'pt_BR',
                  symbol: 'R\$',
                );

                return Card(
                  child: ListTile(
                    title: Text(transaction.description),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('dd/MM/yyyy').format(transaction.date)),
                        if (transaction.paymentMethod != null)
                          Text(transaction.paymentMethod!.name),
                        if (transaction.installmentNumber != null)
                          Text(
                              '${transaction.installmentNumber}/${transaction.totalInstallments}'),
                      ],
                    ),
                    trailing: Text(
                      currencyFormat.format(transaction.amount),
                      style: TextStyle(
                        color: transaction.type == TransactionType.income
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppConstants.addTransactionRoute),
        child: const Icon(Icons.add),
      ),
    );
  }
}
