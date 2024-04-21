import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth.g.dart';
part 'firebase_auth.freezed.dart';

@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required bool loaded,
    required String? uid,
    required String? email,
  }) = _AuthUser;
}

@Riverpod(keepAlive: true)
Stream<AuthUser?> firebaseAuth(FirebaseAuthRef ref) =>
    FirebaseAuth.instance.authStateChanges().map(
          (user) => AuthUser(
            loaded: true,
            uid: user?.uid,
            email: user?.email,
          ),
        );
