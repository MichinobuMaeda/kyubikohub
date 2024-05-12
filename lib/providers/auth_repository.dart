import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/data_state.dart';

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
class AuthRepository extends _$AuthRepository {
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
      onError: (error, stackTrace) {
        state = Error(error: error, stackTrace: stackTrace);
      },
    );
    return const Loading();
  }
}

Future<String?> loginWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  if (email.isEmpty) {
    return 'email-required';
  } else if (password.isEmpty) {
    return 'password-required';
  }
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return null;
  } catch (e) {
    debugPrint(e.toString());
    return e
        .toString()
        .replaceFirst(RegExp(r'^[^/]*/'), '')
        .replaceFirst(RegExp(r'].*'), '');
  }
}

Future<void> logout() => FirebaseAuth.instance.signOut();
