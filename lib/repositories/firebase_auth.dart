import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/data_state.dart';

part 'firebase_auth.g.dart';
part 'firebase_auth.freezed.dart';

@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String uid,
    required String? email,
  }) = _AuthUser;
}

@Riverpod(keepAlive: true)
class FirebaseAuthRepository extends _$FirebaseAuthRepository {
  @override
  DataState<AuthUser?> build() {
    FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        state = Success(
          data: user == null
              ? null
              : AuthUser(
                  uid: user.uid,
                  email: user.email,
                ),
        );
      },
      onError: (error, stackTrace) => Error(
        error: error,
        stackTrace: stackTrace,
      ),
    );
    return const Loading();
  }
}
