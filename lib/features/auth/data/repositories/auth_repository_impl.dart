import 'package:lumimoney_app/features/auth/domain/entities/user.dart';
import 'package:lumimoney_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:lumimoney_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:lumimoney_app/core/storage/secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    final token = await remoteDataSource.login(email, password);
    await SecureStorage.saveToken(token);
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<void> register(String email, String password) async {
    await remoteDataSource.register(email, password);
  }

  @override
  Future<void> logout() async {
    await SecureStorage.clearAll();
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> loginWithGoogle() async {
    final token = await remoteDataSource.loginWithGoogle();
    await SecureStorage.saveToken(token);
    return await remoteDataSource.getCurrentUser();
  }
}
