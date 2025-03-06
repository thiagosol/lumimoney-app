import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/credit_card_invoice.dart';
import 'package:lumimoney_app/features/transactions/domain/enums/transaction_enums.dart';

class Transaction {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final TransactionFrequency frequency;
  final TransactionStatus status;
  final int? installmentNumber;
  final int? totalInstallments;
  final PaymentMethod paymentMethod;
  final CreditCardInvoice? creditCardInvoice;
  final String? recurrenceId;
  final DateTime date;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.frequency,
    required this.status,
    this.installmentNumber,
    this.totalInstallments,
    required this.paymentMethod,
    this.creditCardInvoice,
    this.recurrenceId,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.value == json['type'],
        orElse: () => TransactionType.expense,
      ),
      frequency: TransactionFrequency.values.firstWhere(
        (e) => e.value == json['frequency'],
        orElse: () => TransactionFrequency.unitary,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.value == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      installmentNumber: json['installmentNumber'],
      totalInstallments: json['totalInstallments'],
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod']),
      creditCardInvoice: json['creditCardInvoice'] != null
          ? CreditCardInvoice.fromJson(json['creditCardInvoice'])
          : null,
      recurrenceId: json['recurrenceId'],
      date: DateTime.parse(json['date']),
    );
  }
} 