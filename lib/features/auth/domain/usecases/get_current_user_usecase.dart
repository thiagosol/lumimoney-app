import 'package:lumimoney_app/features/auth/domain/entities/user.dart';
import 'package:lumimoney_app/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User?> execute() {
    return repository.getCurrentUser();
  }
}
