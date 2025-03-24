import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/exceptions/app_exception.dart';
import 'package:lumimoney_app/network/http_client.dart';
import 'package:lumimoney_app/models/user.dart';
import 'package:lumimoney_app/service/auth_service.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthController(this._authService) : super(AuthState());

  Future<void> login() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _authService.login();
    } catch (e) {
      state = state.copyWith(
        error: e is AppException ? e.message : e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> getCurrentUser() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authService.getCurrentUser();
      state = state.copyWith(user: user, isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(
        error: e is AppException ? e.message : e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _authService.logout();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(
        error: e is AppException ? e.message : e.toString(),
        isLoading: false,
      );
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final httpClient = ref.watch(appHttpClientProvider);
  final authService = AuthService(httpClient);
  return AuthController(authService);
});
