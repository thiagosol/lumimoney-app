import 'package:flutter/material.dart';
import 'package:lumimoney_app/core/utils/money_formatter.dart';

class MoneyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const MoneyTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.onChanged,
  });

  @override
  State<MoneyTextField> createState() => _MoneyTextFieldState();
}

class _MoneyTextFieldState extends State<MoneyTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = '0,00';
  }

  void _handleChange(String value) {
    final formatted = MoneyFormatter.format(value);
    widget.controller.text = formatted;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: formatted.length),
    );

    if (widget.onChanged != null) {
      widget.onChanged!(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        prefixText: 'R\$ ',
      ),
      keyboardType: TextInputType.number,
      onChanged: _handleChange,
      validator: widget.validator,
    );
  }
} 