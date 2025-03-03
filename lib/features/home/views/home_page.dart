import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/features/auth/providers/auth_provider.dart';
import 'package:lumimoney_app/features/home/models/payment_method.dart';
import 'package:lumimoney_app/features/home/services/payment_method_service.dart';
import 'package:lumimoney_app/features/home/widgets/payment_method_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<PaymentMethodModel> accounts = [];
  List<PaymentMethodModel> cards = [];

  @override
  void initState() {
    super.initState();
    _fetchPaymentMethods();
  }

  Future<void> _fetchPaymentMethods() async {
    final paymentMethods = await PaymentMethodService().getAll();
    setState(() {
      accounts = paymentMethods.where((p) => p.type == 'ACCOUNT').toList();
      cards = paymentMethods.where((p) => p.type == 'CREDIT_CARD').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LumiMoney'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bem-vindo, ${user?.email ?? 'usuário'}!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),

            _buildSection('Contas', 'Criar conta', accounts, onNewPressed: () {
            },),

            const SizedBox(height: 24),

            _buildSection('Cartões', 'Criar cartão', cards, onNewPressed: () {
            },),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String btnNewTitle, List<PaymentMethodModel> items, {required VoidCallback onNewPressed}) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            if (items.isEmpty) {
              return const Text('Nenhum.');
            }
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: items.map((item) {
                return SizedBox(
                  width: isWeb ? (constraints.maxWidth / 3) - 12 : double.infinity,
                  child: PaymentMethodWidget(paymentMethod: item),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: onNewPressed,
            icon: const Icon(Icons.add),
            label: Text(btnNewTitle),
          ),
        ),
      ],
    );
  }
}
