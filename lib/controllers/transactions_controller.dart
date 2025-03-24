import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/network/http_client.dart';
import 'package:lumimoney_app/models/transaction.dart';
import 'package:lumimoney_app/models/transaction_request.dart';
import 'package:lumimoney_app/service/transaction_service.dart';

final transactionsControllerProvider =
    StateNotifierProvider<TransactionsController, TransactionsState>((ref) {
  final httpClient = ref.watch(appHttpClientProvider);
  final transactionService = TransactionService(httpClient);
  return TransactionsController(transactionService);
});

class TransactionsController extends StateNotifier<TransactionsState> {
  final TransactionService transactionService;

  TransactionsController(this.transactionService)
      : super(const TransactionsState.initial());

  Future<void> createTransaction(TransactionRequest request) async {
    state = const TransactionsState.loading();

    try {
      await transactionService.createTransaction(request);
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
      final transactions = await transactionService.getTransactionsByMonth(
        yearMonth,
        type,
        id,
      );
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
