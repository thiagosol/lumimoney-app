import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:lumimoney_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lumimoney_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:lumimoney_app/core/network/http_client.dart';

final httpClientProvider = Provider((ref) => AppHttpClient());

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return AuthRemoteDataSourceImpl(client);
});

final authRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

final loginUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

final loginWithGoogleUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginWithGoogleUseCase(repository);
});
