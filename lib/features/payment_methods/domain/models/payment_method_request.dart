import 'package:equatable/equatable.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method.dart';

abstract class PaymentMethodRequest extends Equatable {
  final String name;
  final PaymentMethodType type;

  const PaymentMethodRequest({
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.name,
      };

  @override
  List<Object?> get props => [name, type];
}

class AccountRequest extends PaymentMethodRequest {
  final double? initialBalance;

  const AccountRequest({
    required super.name,
    this.initialBalance,
  }) : super(type: PaymentMethodType.account);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'account': {
          if (initialBalance != null) 'initialBalance': initialBalance,
        },
      };

  @override
  List<Object?> get props => [...super.props, initialBalance];
}

class CreditCardRequest extends PaymentMethodRequest {
  final int dueDayOfMonth;
  final int closingDayOfMonth;
  final double creditLimit;

  const CreditCardRequest({
    required super.name,
    required this.dueDayOfMonth,
    required this.closingDayOfMonth,
    required this.creditLimit,
  }) : super(type: PaymentMethodType.creditCard);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'creditCard': {
          'dueDayOfMonth': dueDayOfMonth,
          'closingDayOfMonth': closingDayOfMonth,
          'creditLimit': creditLimit,
        },
      };

  @override
  List<Object?> get props => [
        ...super.props,
        dueDayOfMonth,
        closingDayOfMonth,
        creditLimit,
      ];
} 