import 'package:flutter/material.dart';
import 'package:lumimoney_app/features/home/models/payment_method.dart';

class PaymentMethodWidget extends StatelessWidget {
  final PaymentMethodModel paymentMethod;

  const PaymentMethodWidget({super.key, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    final isCard = paymentMethod.type == 'CREDIT_CARD';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(paymentMethod.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Saldo: R\$ ${paymentMethod.balance?.toStringAsFixed(2)}'),
            if (isCard && paymentMethod.dueDate != null) ...[
              const SizedBox(height: 8),
              Text('Vence: ${_formatDate(paymentMethod.dueDate!)}'),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
