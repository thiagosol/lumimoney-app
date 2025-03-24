import 'package:dio/dio.dart';
import 'package:lumimoney_app/models/transaction.dart';
import 'package:lumimoney_app/models/transaction_request.dart';
import 'package:lumimoney_app/network/api_endpoints.dart';
import 'package:lumimoney_app/network/http_client.dart';

class TransactionService {
  final AppHttpClient httpClient;

  TransactionService(this.httpClient);

  Future<void> createTransaction(TransactionRequest request) async {
    try {
      await httpClient.post(ApiEndpoints.transactions, data: request.toJson());
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Falha ao criar transação',
      );
    }
  }

  Future<List<Transaction>> getTransactionsByMonth(
    String yearMonth, [
    String? type,
    String? id,
  ]) async {
    try {
      String url = '${ApiEndpoints.transactions}/month/$yearMonth';
      if (type != null) {
        url += '?type=$type';
        if (id != null) {
          url += '&id=$id';
        }
      }

      final response = await httpClient.get(url);
      return (response.data as List)
          .map((json) => Transaction.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Falha ao buscar transações',
      );
    }
  }
}
