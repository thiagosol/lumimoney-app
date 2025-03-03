// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodModelImpl _$$PaymentMethodModelImplFromJson(
        Map<String, dynamic> json,) =>
    _$PaymentMethodModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      balance: (json['balance'] as num?)?.toDouble(),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
    );

Map<String, dynamic> _$$PaymentMethodModelImplToJson(
        _$PaymentMethodModelImpl instance,) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'balance': instance.balance,
      'dueDate': instance.dueDate?.toIso8601String(),
    };
