import 'package:lumimoney_app/features/auth/domain/entities/user.dart';
import 'package:lumimoney_app/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogleUseCase {
  final AuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  Future<User> execute() {
    return repository.loginWithGoogle();
  }
}
