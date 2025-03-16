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
  final String? recurrenceId;
  final DateTime date;
  final PaymentMethod? paymentMethod;
  final CreditCardInvoice? creditCardInvoice;
  final bool isVirtual;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.frequency,
    required this.status,
    this.installmentNumber,
    this.totalInstallments,
    this.recurrenceId,
    required this.date,
    this.paymentMethod,
    this.creditCardInvoice,
    required this.isVirtual,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      type: TransactionType.values.firstWhere((e) => e.value == json['type']),
      frequency: TransactionFrequency.values
          .firstWhere((e) => e.value == json['frequency']),
      status:
          TransactionStatus.values.firstWhere((e) => e.value == json['status']),
      installmentNumber: json['installmentNumber'],
      totalInstallments: json['totalInstallments'],
      recurrenceId: json['recurrenceId'],
      date: DateTime.parse(json['date']),
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethod.fromJson(json['paymentMethod'])
          : null,
      creditCardInvoice: json['creditCardInvoice'] != null
          ? CreditCardInvoice.fromJson(json['creditCardInvoice'])
          : null,
      isVirtual: json['isVirtual'],
    );
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final String type;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
}

class CreditCardInvoice {
  final String creditCardId;
  final DateTime dueDate;
  final double amount;

  CreditCardInvoice({
    required this.creditCardId,
    required this.dueDate,
    required this.amount,
  });

  factory CreditCardInvoice.fromJson(Map<String, dynamic> json) {
    return CreditCardInvoice(
      creditCardId: json['creditCardId'],
      dueDate: DateTime.parse(json['dueDate']),
      amount: json['amount'].toDouble(),
    );
  }
}
