import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumimoney_app/core/exceptions/app_exception.dart';
import 'package:lumimoney_app/features/auth/domain/entities/user.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:lumimoney_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:lumimoney_app/shared/constants/app_constants.dart';

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
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;

  AuthController(
    this._loginUseCase,
    this._registerUseCase,
    this._getCurrentUserUseCase,
    this._loginWithGoogleUseCase,
  ) : super(AuthState());

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> login(
    String email,
    String password, {
    BuildContext? context,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _loginUseCase.execute(email, password);
      state = state.copyWith(user: user, isLoading: false, clearError: true);
      if (context != null && context.mounted) {
        context.go(AppConstants.homeRoute);
      }
    } catch (e) {
      state = state.copyWith(
        error: e is AppException ? e.message : e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> register(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _registerUseCase.execute(email, password);
      state = state.copyWith(isLoading: false, clearError: true);
      if (context.mounted) {
        context.go(
          AppConstants.loginRoute,
          extra: {'email': email},
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e is AppException ? e.message : e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> loginWithGoogle({BuildContext? context}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _loginWithGoogleUseCase.execute();
      state = state.copyWith(user: user, isLoading: false, clearError: true);
      if (context != null && context.mounted) {
        context.go(AppConstants.homeRoute);
      }
    } catch (e) {
      state = state.copyWith(
        error: e is AppException ? e.message : e.toString(),
        isLoading: false,
      );
    }
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

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _loginUseCase.repository.logout();
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
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final registerUseCase = ref.watch(registerUseCaseProvider);
  final getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);
  final loginWithGoogleUseCase = ref.watch(loginWithGoogleUseCaseProvider);

  return AuthController(
    loginUseCase,
    registerUseCase,
    getCurrentUserUseCase,
    loginWithGoogleUseCase,
  );
});
