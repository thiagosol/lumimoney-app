import 'package:dio/dio.dart';
import 'package:lumimoney_app/network/api_endpoints.dart';
import 'package:lumimoney_app/network/http_client.dart';
import 'package:lumimoney_app/models/payment_method.dart';
import 'package:lumimoney_app/models/payment_method_request.dart';

class PaymentMethodsService {
  final AppHttpClient httpClient;

  PaymentMethodsService(this.httpClient);

  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final response = await httpClient.get(ApiEndpoints.paymentMethods);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => PaymentMethod.fromJson(json)).toList();
      }

      throw Exception('Falha ao buscar métodos de pagamento');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Falha ao buscar métodos de pagamento',
      );
    }
  }

  Future<PaymentMethod> createPaymentMethod(
    PaymentMethodRequest request,
  ) async {
    try {
      final response = await httpClient.post(
        ApiEndpoints.paymentMethods,
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return PaymentMethod.fromJson(response.data);
      }

      throw Exception('Falha ao criar método de pagamento');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Falha ao criar método de pagamento',
      );
    }
  }
}
