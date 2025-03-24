import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyTextField extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CurrencyTextField({
    super.key,
    required this.controller,
    this.decoration,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: decoration,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: validator,
      onChanged: (value) {
        if (value.isEmpty) {
          controller.text = '';
          if (onChanged != null) onChanged!('');
          return;
        }

        final number = int.tryParse(value);
        if (number == null) return;

        final currencyFormat = NumberFormat.currency(
          locale: 'pt_BR',
          symbol: 'R\$',
          decimalDigits: 2,
        );

        final formattedValue = currencyFormat.format(number / 100);
        controller.value = TextEditingValue(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );

        if (onChanged != null) onChanged!(formattedValue);
      },
    );
  }
} 