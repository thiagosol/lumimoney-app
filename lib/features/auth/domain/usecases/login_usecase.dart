import 'package:lumimoney_app/features/auth/domain/entities/user.dart';
import 'package:lumimoney_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> execute(String email, String password) {
    return repository.login(email, password);
  }
}
