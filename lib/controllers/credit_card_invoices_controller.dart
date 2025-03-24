import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/network/http_client.dart';
import 'package:lumimoney_app/models/credit_card_invoice.dart';

final creditCardInvoicesControllerProvider = StateNotifierProvider<
    CreditCardInvoicesController, CreditCardInvoicesState>((ref) {
  final httpClient = ref.watch(appHttpClientProvider);
  return CreditCardInvoicesController(httpClient);
});

class CreditCardInvoicesController
    extends StateNotifier<CreditCardInvoicesState> {
  final AppHttpClient httpClient;

  CreditCardInvoicesController(this.httpClient)
      : super(const CreditCardInvoicesState.initial());

  void clearState() {
    state = const CreditCardInvoicesState.initial();
  }

  Future<void> getInvoices(String paymentMethodId) async {
    if (paymentMethodId.isEmpty) {
      clearState();
      return;
    }

    state = const CreditCardInvoicesState.loading();

    try {
      final response = await httpClient.get(
        '/credit-card-invoices/payment-method/$paymentMethodId?isClosed=false',
      );
      final List<dynamic> responseList = response.data as List<dynamic>;
      final invoices =
          responseList.map((json) => CreditCardInvoice.fromJson(json)).toList();
      invoices.sort((a, b) => b.dueDate.compareTo(a.dueDate));
      state = CreditCardInvoicesState.success(invoices);
    } catch (e) {
      state = CreditCardInvoicesState.error(e.toString());
    }
  }
}

class CreditCardInvoicesState {
  final bool isLoading;
  final String? error;
  final List<CreditCardInvoice> invoices;

  const CreditCardInvoicesState({
    required this.isLoading,
    this.error,
    required this.invoices,
  });

  const CreditCardInvoicesState.initial()
      : this(
          isLoading: false,
          invoices: const [],
        );

  const CreditCardInvoicesState.loading()
      : this(
          isLoading: true,
          invoices: const [],
        );

  const CreditCardInvoicesState.success(List<CreditCardInvoice> invoices)
      : this(
          isLoading: false,
          invoices: invoices,
        );

  const CreditCardInvoicesState.error(String error)
      : this(
          isLoading: false,
          error: error,
          invoices: const [],
        );
}
