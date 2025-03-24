import 'package:lumimoney_app/models/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.user,
    required this.isLoading,
    this.error,
  });

  factory AuthState.initial() =>
      const AuthState(user: null, isLoading: false, error: null);

  factory AuthState.loggedIn(UserModel user) =>
      AuthState(user: user, isLoading: false);

  factory AuthState.loggedOut() =>
      const AuthState(user: null, isLoading: false);

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
