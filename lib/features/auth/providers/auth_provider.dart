import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/core/exceptions/app_exception.dart';
import 'package:lumimoney_app/features/auth/models/user.dart';
import 'package:lumimoney_app/features/auth/services/auth_service.dart';
import 'package:hive/hive.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.user,
    required this.isLoading,
    this.error,
  });

  factory AuthState.initial() => AuthState(user: null, isLoading: false);

  factory AuthState.loggedIn(UserModel user) => AuthState(user: user, isLoading: false);

  factory AuthState.loggedOut() => AuthState(user: null, isLoading: false);

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService = AuthService();

  AuthNotifier() : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await _authService.login(email, password);
      await _saveUser(email, token);
    } on Exception catch (e) {
      _handleError(e);
    }
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await _authService.register(email, password);
      await _saveUser(email, token);
    } on Exception catch (e) {
      _handleError(e);
    }
  }

  Future<void> loginWithGoogle(String email, String accessToken) async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await _authService.loginWithGoogle(accessToken);
      await _saveUser(email, token);
    } on Exception catch (e) {
      _handleError(e);
    }
  }

  Future<void> loadUserFromStorage() async {
    final boxExists = await Hive.boxExists('userBox');
    if (!boxExists) {
      state = AuthState.loggedOut();
      return;
    }

    final box = await Hive.openBox('userBox');
    final email = box.get('email');
    final token = box.get('token');

    if (email != null && token != null) {
      state = AuthState.loggedIn(UserModel(email: email, token: token));
    } else {
      state = AuthState.loggedOut();
    }
  }

  Future<void> _saveUser(String email, String token) async {
    final box = await Hive.openBox('userBox');
    await box.put('email', email);
    await box.put('token', token);

    state = AuthState.loggedIn(UserModel(email: email, token: token));
  }

  void _handleError(Exception e) {
    final errorMessage = e is AppException ? e.message : "Ocorreu um erro.";
    state = state.copyWith(isLoading: false, error: errorMessage);
  }
}


final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
