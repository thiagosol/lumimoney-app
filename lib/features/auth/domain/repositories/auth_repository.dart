import 'package:lumimoney_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
}
