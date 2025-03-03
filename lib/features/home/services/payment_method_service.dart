import 'package:lumimoney_app/core/exceptions/app_exception.dart';
import 'package:lumimoney_app/core/app_http_client.dart';
import 'package:lumimoney_app/features/home/models/payment_method.dart';

class PaymentMethodService {
  final AppHttpClient _http = AppHttpClient();

  Future<List<PaymentMethodModel>> getAll() async {
    final response = await _http.get('/payment-methods');
    if (response.statusCode != 200) {
      throw AppException('Erro ao buscar métodos de pagamento');
    }
    return (response.data as List)
        .map((e) => PaymentMethodModel.fromJson(e))
        .toList();
  }
}
