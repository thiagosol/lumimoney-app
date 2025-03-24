import 'package:lumimoney_app/features/auth/data/models/user_model.dart';
import 'package:lumimoney_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:lumimoney_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserModel> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }
}
