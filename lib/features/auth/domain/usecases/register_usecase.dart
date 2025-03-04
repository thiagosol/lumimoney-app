import 'package:lumimoney_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> execute(String email, String password) {
    return repository.register(email, password);
  }
}
