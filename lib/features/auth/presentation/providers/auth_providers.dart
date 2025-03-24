import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumimoney_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lumimoney_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:lumimoney_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:lumimoney_app/core/network/http_client.dart';
import 'package:lumimoney_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lumimoney_app/features/auth/presentation/controllers/auth_controller.dart';

final httpClientProvider = Provider((ref) => AppHttpClient());

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return AuthRemoteDataSourceImpl(client);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);
  return AuthController(getCurrentUserUseCase, logoutUseCase);
});
