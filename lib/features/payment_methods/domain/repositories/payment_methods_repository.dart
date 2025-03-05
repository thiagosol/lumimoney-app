import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method_request.dart';

abstract class PaymentMethodsRepository {
  Future<List<PaymentMethod>> getPaymentMethods();
  Future<PaymentMethod> createPaymentMethod(PaymentMethodRequest request);
}
