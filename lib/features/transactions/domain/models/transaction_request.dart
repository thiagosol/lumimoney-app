import 'package:lumimoney_app/features/transactions/domain/enums/transaction_enums.dart';

class TransactionRequest {
  final String description;
  final double amount;
  final TransactionType type;
  final TransactionFrequency frequency;
  final TransactionStatus status;
  final int? totalInstallments;
  final String paymentMethod;
  final String? creditCardInvoice;
  final DateTime date;

  TransactionRequest({
    required this.description,
    required this.amount,
    required this.type,
    required this.frequency,
    required this.status,
    this.totalInstallments,
    required this.paymentMethod,
    required this.creditCardInvoice,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amount': amount.toString(),
      'type': type.value,
      'frequency': frequency.value,
      'status': status.value,
      if (totalInstallments != null) 'totalInstallments': totalInstallments,
      'paymentMethod': paymentMethod,
      'creditCardInvoice': creditCardInvoice,
      'date': date.toIso8601String(),
    };
  }
} 