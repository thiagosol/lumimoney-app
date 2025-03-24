import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/core/exceptions/app_exception.dart';
import 'package:lumimoney_app/features/auth/domain/entities/user.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lumimoney_app/features/auth/presentation/providers/auth_providers.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
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
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthController(
    this._getCurrentUserUseCase,
    this._logoutUseCase,
  ) : super(AuthState());

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> checkAuthState() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _getCurrentUserUseCase.execute();
      state = state.copyWith(user: user, isLoading: false, clearError: true);
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
      final user = await _getCurrentUserUseCase.execute();
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
      await _logoutUseCase();
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
  final getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);
  return AuthController(getCurrentUserUseCase, logoutUseCase);
});
