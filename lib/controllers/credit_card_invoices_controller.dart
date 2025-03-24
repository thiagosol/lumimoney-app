import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/network/http_client.dart';
import 'package:lumimoney_app/models/credit_card_invoice.dart';
import 'package:lumimoney_app/service/credit_card_invoices_service.dart';

final creditCardInvoicesControllerProvider = StateNotifierProvider<
    CreditCardInvoicesController, CreditCardInvoicesState>((ref) {
  final httpClient = ref.watch(appHttpClientProvider);
  final creditCardInvoicesService = CreditCardInvoicesService(httpClient);
  return CreditCardInvoicesController(
    creditCardInvoicesService,
  );
});

class CreditCardInvoicesController
    extends StateNotifier<CreditCardInvoicesState> {
  final CreditCardInvoicesService creditCardInvoicesService;

  CreditCardInvoicesController(this.creditCardInvoicesService)
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
      final invoices = await creditCardInvoicesService.getInvoices(
        paymentMethodId,
      );
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
