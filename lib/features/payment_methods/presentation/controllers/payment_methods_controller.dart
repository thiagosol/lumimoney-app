import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/core/network/http_client.dart';
import 'package:lumimoney_app/features/payment_methods/data/datasources/payment_methods_remote_datasource.dart';
import 'package:lumimoney_app/features/payment_methods/data/repositories/payment_methods_repository_impl.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method.dart';
import 'package:lumimoney_app/features/payment_methods/domain/models/payment_method_request.dart';

final paymentMethodsControllerProvider =
    StateNotifierProvider<PaymentMethodsController, PaymentMethodsState>((ref) {
  final httpClient = ref.watch(appHttpClientProvider);
  final dataSource = PaymentMethodsRemoteDataSourceImpl(httpClient);
  final repository = PaymentMethodsRepositoryImpl(dataSource);
  return PaymentMethodsController(repository);
});

class PaymentMethodsController extends StateNotifier<PaymentMethodsState> {
  final PaymentMethodsRepositoryImpl repository;

  PaymentMethodsController(this.repository)
      : super(const PaymentMethodsState.initial());

  Future<void> getPaymentMethods() async {
    state = const PaymentMethodsState.loading();

    try {
      final paymentMethods = await repository.getPaymentMethods();
      state = PaymentMethodsState.success(paymentMethods);
    } catch (e) {
      state = PaymentMethodsState.error(e.toString());
    }
  }

  Future<void> createPaymentMethod(PaymentMethodRequest request) async {
    state = const PaymentMethodsState.loading();

    try {
      final paymentMethod = await repository.createPaymentMethod(request);
      state = PaymentMethodsState.success([...state.paymentMethods, paymentMethod]);
    } catch (e) {
      state = PaymentMethodsState.error(e.toString());
    }
  }

  Future<void> addAccount(String name, double initialBalance) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = AccountRequest(
        name: name,
        initialBalance: initialBalance,
      );
      await repository.createPaymentMethod(request);
      await getPaymentMethods();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addCard(
    String name,
    double creditLimit,
    int dueDay,
    int closingDay,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = CreditCardRequest(
        name: name,
        dueDayOfMonth: dueDay,
        closingDayOfMonth: closingDay,
        creditLimit: creditLimit,
      );
      await repository.createPaymentMethod(request);
      await getPaymentMethods();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

class PaymentMethodsState {
  final bool isLoading;
  final String? error;
  final List<PaymentMethod> paymentMethods;

  const PaymentMethodsState({
    required this.isLoading,
    this.error,
    required this.paymentMethods,
  });

  const PaymentMethodsState.initial()
      : this(
          isLoading: false,
          paymentMethods: const [],
        );

  const PaymentMethodsState.loading()
      : this(
          isLoading: true,
          paymentMethods: const [],
        );

  const PaymentMethodsState.success(List<PaymentMethod> paymentMethods)
      : this(
          isLoading: false,
          paymentMethods: paymentMethods,
        );

  const PaymentMethodsState.error(String error)
      : this(
          isLoading: false,
          error: error,
          paymentMethods: const [],
        );

  PaymentMethodsState copyWith({
    bool? isLoading,
    String? error,
    List<PaymentMethod>? paymentMethods,
  }) {
    return PaymentMethodsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }
}
