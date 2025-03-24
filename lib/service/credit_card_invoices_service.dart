import 'package:dio/dio.dart';
import 'package:lumimoney_app/models/credit_card_invoice.dart';
import 'package:lumimoney_app/network/api_endpoints.dart';
import 'package:lumimoney_app/network/http_client.dart';

class CreditCardInvoicesService {
  final AppHttpClient httpClient;

  CreditCardInvoicesService(this.httpClient);

  Future<List<CreditCardInvoice>> getInvoices(String paymentMethodId) async {
    try {
      final response = await httpClient.get(
        '${ApiEndpoints.creditCardInvoices}/payment-method/$paymentMethodId?isClosed=false',
      );

      if (response.statusCode != 200) {
        throw Exception('Falha ao buscar faturas de cartão');
      }

      final List<dynamic> responseList = response.data as List<dynamic>;
      final invoices =
          responseList.map((json) => CreditCardInvoice.fromJson(json)).toList();
      invoices.sort((a, b) => b.dueDate.compareTo(a.dueDate));
      return invoices;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Falha ao buscar faturas de cartão',
      );
    }
  }
}
