import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/core/network/http_client.dart';
import 'package:lumimoney_app/features/transactions/domain/models/transaction_request.dart';

final transactionsControllerProvider =
    StateNotifierProvider<TransactionsController, TransactionsState>((ref) {
  final httpClient = ref.watch(appHttpClientProvider);
  return TransactionsController(httpClient);
});

class TransactionsController extends StateNotifier<TransactionsState> {
  final AppHttpClient httpClient;

  TransactionsController(this.httpClient) : super(const TransactionsState.initial());

  Future<void> createTransaction(TransactionRequest request) async {
    state = const TransactionsState.loading();

    try {
      await httpClient.post('/transactions', data: request.toJson());
      state = const TransactionsState.success();
    } catch (e) {
      state = TransactionsState.error(e.toString());
    }
  }
}

class TransactionsState {
  final bool isLoading;
  final String? error;
  final bool success;

  const TransactionsState({
    required this.isLoading,
    this.error,
    required this.success,
  });

  const TransactionsState.initial()
      : this(
          isLoading: false,
          success: false,
        );

  const TransactionsState.loading()
      : this(
          isLoading: true,
          success: false,
        );

  const TransactionsState.success()
      : this(
          isLoading: false,
          success: true,
        );

  const TransactionsState.error(String error)
      : this(
          isLoading: false,
          error: error,
          success: false,
        );
} 