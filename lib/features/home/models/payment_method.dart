class PaymentMethodModel {
  final String id;
  final String name;
  final String type;
  final double? balance;
  final DateTime? dueDate;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.type,
    this.balance,
    this.dueDate,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }   
}
