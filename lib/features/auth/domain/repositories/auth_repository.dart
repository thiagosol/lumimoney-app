import 'package:lumimoney_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> register(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<User> loginWithGoogle();
}
