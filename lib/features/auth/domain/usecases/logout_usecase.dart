import 'package:lumimoney_app/core/storage/secure_storage.dart';
import 'package:lumimoney_app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    await SecureStorage.clearAll();
  }
}
