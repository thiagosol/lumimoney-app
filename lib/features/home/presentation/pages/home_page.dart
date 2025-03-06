import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumimoney_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method.dart';
import 'package:lumimoney_app/features/payment_methods/presentation/controllers/payment_methods_controller.dart';
import 'package:lumimoney_app/shared/constants/app_constants.dart';
import 'package:lumimoney_app/features/transactions/presentation/pages/transactions_test_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentMethodsControllerProvider.notifier).getPaymentMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    final paymentMethodsState = ref.watch(paymentMethodsControllerProvider);
    final accounts = paymentMethodsState.paymentMethods
        .where((pm) => pm.type == PaymentMethodType.account)
        .toList();
    final creditCards = paymentMethodsState.paymentMethods
        .where((pm) => pm.type == PaymentMethodType.creditCard)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('LumiMoney'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
              context.go(AppConstants.loginRoute);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(paymentMethodsControllerProvider.notifier).getPaymentMethods();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bem-vindo, ${user?.email}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                title: 'Minhas Contas',
                onAddPressed: () => context.push(AppConstants.addAccountRoute),
                child: _buildAccountsList(accounts),
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                title: 'Meus Cartões',
                onAddPressed: () => context.push(AppConstants.addCardRoute),
                child: _buildCreditCardsList(creditCards),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionsTestPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.list),
                label: const Text('Teste de Transações'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppConstants.addTransactionRoute),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required VoidCallback onAddPressed,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildAccountsList(List<PaymentMethod> accounts) {
    if (accounts.isEmpty) {
      return const Center(
        child: Text('Nenhuma conta cadastrada'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 600;
        if (isWeb) {
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: accounts.map((account) => _buildAccountCard(account)).toList(),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: accounts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _buildAccountCard(accounts[index]),
        );
      },
    );
  }

  Widget _buildCreditCardsList(List<PaymentMethod> cards) {
    if (cards.isEmpty) {
      return const Center(
        child: Text('Nenhum cartão cadastrado'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 600;
        if (isWeb) {
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: cards.map((card) => _buildCreditCardCard(card)).toList(),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _buildCreditCardCard(cards[index]),
        );
      },
    );
  }

  Widget _buildAccountCard(PaymentMethod account) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormat.format(account.account?.balance ?? 0),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreditCardCard(PaymentMethod card) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Fatura atual: ${currencyFormat.format(card.lastOpenInvoice?.totalAmount ?? 0)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              if (card.lastOpenInvoice != null)
                Text(
                  'Vencimento: ${dateFormat.format(card.lastOpenInvoice!.dueDate)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
