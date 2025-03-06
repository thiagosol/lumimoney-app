import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/features/transactions/domain/models/transaction.dart';
import 'package:lumimoney_app/core/network/http_client.dart';

class TransactionsListState {
  final List<Transaction> transactions;
  final bool isLoading;
  final String? error;

  TransactionsListState({
    this.transactions = const [],
    this.isLoading = false,
    this.error,
  });

  TransactionsListState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    String? error,
  }) {
    return TransactionsListState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TransactionsListController extends StateNotifier<TransactionsListState> {
  final AppHttpClient _httpClient;

  TransactionsListController(this._httpClient) : super(TransactionsListState());

  Future<void> getTransactions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _httpClient.get('/transactions');
      final transactions = (response.data as List)
          .map((json) => Transaction.fromJson(json))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      state = state.copyWith(
        transactions: transactions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final transactionsListControllerProvider =
    StateNotifierProvider<TransactionsListController, TransactionsListState>(
  (ref) => TransactionsListController(ref.watch(appHttpClientProvider)),
); 