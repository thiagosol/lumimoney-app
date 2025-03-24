import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/core/network/http_client.dart';
import 'package:lumimoney_app/features/transactions/domain/models/transaction.dart';
import 'package:lumimoney_app/features/transactions/domain/models/transaction_request.dart';

final transactionsControllerProvider =
    StateNotifierProvider<TransactionsController, TransactionsState>((ref) {
  final httpClient = ref.watch(appHttpClientProvider);
  return TransactionsController(httpClient);
});

class TransactionsController extends StateNotifier<TransactionsState> {
  final AppHttpClient httpClient;

  TransactionsController(this.httpClient)
      : super(const TransactionsState.initial());

  Future<void> createTransaction(TransactionRequest request) async {
    state = const TransactionsState.loading();

    try {
      await httpClient.post('/transactions', data: request.toJson());
      state = const TransactionsState.success();
    } catch (e) {
      state = TransactionsState.error(e.toString());
    }
  }

  Future<void> getTransactionsByMonth(
    String yearMonth, [
    String? type,
    String? id,
  ]) async {
    state = const TransactionsState.loading();

    try {
      String url = '/transactions/month/$yearMonth';
      if (type != null) {
        url += '?type=$type';
        if (id != null) {
          url += '&id=$id';
        }
      }

      final response = await httpClient.get(url);
      final transactions = (response.data as List)
          .map((json) => Transaction.fromJson(json))
          .toList();

      state = TransactionsState.data(transactions);
    } catch (e) {
      state = TransactionsState.error(e.toString());
    }
  }
}

class TransactionsState {
  final bool isLoading;
  final String? error;
  final bool success;
  final List<Transaction> transactions;

  const TransactionsState({
    required this.isLoading,
    this.error,
    required this.success,
    required this.transactions,
  });

  const TransactionsState.initial()
      : this(
          isLoading: false,
          success: false,
          transactions: const [],
        );

  const TransactionsState.loading()
      : this(
          isLoading: true,
          success: false,
          transactions: const [],
        );

  const TransactionsState.success()
      : this(
          isLoading: false,
          success: true,
          transactions: const [],
        );

  const TransactionsState.data(List<Transaction> transactions)
      : this(
          isLoading: false,
          success: true,
          transactions: transactions,
        );

  const TransactionsState.error(String error)
      : this(
          isLoading: false,
          error: error,
          success: false,
          transactions: const [],
        );
}
