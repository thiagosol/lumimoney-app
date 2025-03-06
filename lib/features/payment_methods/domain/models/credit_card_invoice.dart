import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method.dart';

class CreditCardInvoice {
  final String id;
  final DateTime dueDate;
  final DateTime closingDate;
  final double totalAmount;
  final bool isClosed;
  final bool isPaid;
  final CreditCard creditCard;

  CreditCardInvoice({
    required this.id,
    required this.dueDate,
    required this.closingDate,
    required this.totalAmount,
    required this.isClosed,
    required this.isPaid,
    required this.creditCard,
  });

  factory CreditCardInvoice.fromJson(Map<String, dynamic> json) {
    return CreditCardInvoice(
      id: json['id'],
      dueDate: DateTime.parse(json['dueDate']),
      closingDate: DateTime.parse(json['closingDate']),
      totalAmount: double.parse(json['totalAmount'].toString()),
      isClosed: json['isClosed'],
      isPaid: json['isPaid'],
      creditCard: CreditCard.fromJson(json['creditCard']),
    );
  }
} 