import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';
part 'auth_repository.freezed.dart';

@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String uid,
    required String? email,
  }) = _AuthUser;
}

@Riverpod(keepAlive: true)
Stream<AuthUser?> authRepository(AuthRepositoryRef ref) =>
    FirebaseAuth.instance.authStateChanges()
        .map(
          (user) => user == null
              ? null
              :AuthUser(
                  uid: user.uid,
                  email: user.email,
                ),
        );
