import 'package:lumimoney_app/features/payment_methods/data/datasources/payment_methods_remote_datasource.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method_request.dart';
import 'package:lumimoney_app/features/payment_methods/domain/repositories/payment_methods_repository.dart';

class PaymentMethodsRepositoryImpl implements PaymentMethodsRepository {
  final PaymentMethodsRemoteDataSource remoteDataSource;

  PaymentMethodsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PaymentMethod>> getPaymentMethods() {
    return remoteDataSource.getPaymentMethods();
  }

  @override
  Future<PaymentMethod> createPaymentMethod(PaymentMethodRequest request) {
    return remoteDataSource.createPaymentMethod(request);
  }
}
