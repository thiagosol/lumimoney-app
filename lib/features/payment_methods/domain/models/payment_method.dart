import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String name;
  final PaymentMethodType type;
  final Invoice? lastOpenInvoice;
  final Account? account;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    this.lastOpenInvoice,
    this.account,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      name: json['name'] as String,
      type: PaymentMethodType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      lastOpenInvoice: json['lastOpenInvoice'] != null
          ? Invoice.fromJson(json['lastOpenInvoice'])
          : null,
      account:
          json['account'] != null ? Account.fromJson(json['account']) : null,
    );
  }

  @override
  List<Object?> get props => [id, name, type, lastOpenInvoice, account];
}

enum PaymentMethodType {
  account('ACCOUNT'),
  creditCard('CREDIT_CARD');

  final String name;
  const PaymentMethodType(this.name);
}

class Account extends Equatable {
  final String id;
  final double balance;

  const Account({
    required this.id,
    required this.balance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      balance: json['balance'] as double,
    );
  }

  @override
  List<Object?> get props => [id, balance];
}

class Invoice extends Equatable {
  final String id;
  final DateTime dueDate;
  final DateTime closingDate;
  final double totalAmount;
  final bool isClosed;
  final bool isPaid;
  final CreditCard creditCard;

  const Invoice({
    required this.id,
    required this.dueDate,
    required this.closingDate,
    required this.totalAmount,
    required this.isClosed,
    required this.isPaid,
    required this.creditCard,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String,
      dueDate: DateTime.parse(json['dueDate']),
      closingDate: DateTime.parse(json['closingDate']),
      totalAmount: json['totalAmount'] as double,
      isClosed: json['isClosed'] as bool,
      isPaid: json['isPaid'] as bool,
      creditCard: CreditCard.fromJson(json['creditCard']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        dueDate,
        closingDate,
        totalAmount,
        isClosed,
        isPaid,
        creditCard,
      ];
}

class CreditCard extends Equatable {
  final String id;
  final int dueDayOfMonth;
  final int closingDayOfMonth;
  final double creditLimit;

  const CreditCard({
    required this.id,
    required this.dueDayOfMonth,
    required this.closingDayOfMonth,
    required this.creditLimit,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['id'] as String,
      dueDayOfMonth: json['dueDayOfMonth'] as int,
      closingDayOfMonth: json['closingDayOfMonth'] as int,
      creditLimit: json['creditLimit'] as double,
    );
  }

  @override
  List<Object?> get props => [id, dueDayOfMonth, closingDayOfMonth, creditLimit];
}
