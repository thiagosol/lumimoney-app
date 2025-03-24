import 'package:flutter/material.dart';
import 'package:lumimoney_app/models/payment_method.dart';

class PaymentMethodSelector extends StatelessWidget {
  final List<PaymentMethod> paymentMethods;
  final String? selectedId;
  final void Function(String) onSelect;

  const PaymentMethodSelector({
    super.key,
    required this.paymentMethods,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final accounts = paymentMethods
        .where((pm) => pm.type == PaymentMethodType.account)
        .toList();
    final cards = paymentMethods
        .where((pm) => pm.type == PaymentMethodType.creditCard)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (accounts.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Contas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...accounts.map(
            (account) => RadioListTile<String>(
              title: Text(account.name),
              value: account.id,
              groupValue: selectedId,
              onChanged: (value) {
                if (value != null) onSelect(value);
              },
            ),
          ),
        ],
        if (cards.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Cartões',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...cards.map(
            (card) => RadioListTile<String>(
              title: Text(card.name),
              value: card.id,
              groupValue: selectedId,
              onChanged: (value) {
                if (value != null) onSelect(value);
              },
            ),
          ),
        ],
      ],
    );
  }
}
