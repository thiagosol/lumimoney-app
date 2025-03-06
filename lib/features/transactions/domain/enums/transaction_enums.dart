enum TransactionType {
  income('INCOME', 'Receita'),
  expense('EXPENSE', 'Despesa');

  final String value;
  final String label;

  const TransactionType(this.value, this.label);
}

enum TransactionFrequency {
  unitary('UNITARY', 'Uma vez'),
  installment('INSTALLMENT', 'Parcelado'),
  fixed('FIXED', 'Fixo');

  final String value;
  final String label;

  const TransactionFrequency(this.value, this.label);
}

enum TransactionStatus {
  pending('PENDING', 'Não pago'),
  paid('PAID', 'Pago');

  final String value;
  final String label;

  const TransactionStatus(this.value, this.label);
} 