import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method.dart';

abstract class PaymentMethodsRepository {
  Future<List<PaymentMethod>> getPaymentMethods();
}
