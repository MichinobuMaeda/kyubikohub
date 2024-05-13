import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config.dart';
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
    return getAuthErrorCode(e);
  }
}

Future<String?> changePassword({
  required String curPassword,
  required String newPassword,
  required String conPassword,
}) async {
  final email = FirebaseAuth.instance.currentUser?.email;
  if (email == null || email.isEmpty) {
    return 'email-required';
  } else if (curPassword.isEmpty) {
    return 'curPassword-required';
  } else if (newPassword.isEmpty) {
    return 'newPassword-required';
  } else if (conPassword.isEmpty) {
    return 'conPassword-required';
  } else if (newPassword != conPassword) {
    return 'password-mismatch';
  } else if (!validatePassword(newPassword)) {
    return 'weak-password';
  }
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: curPassword,
    );
  } catch (e) {
    debugPrint(e.toString());
    return getAuthErrorCode(e);
  }
  try {
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    return null;
  } catch (e) {
    debugPrint(e.toString());
    return getAuthErrorCode(e);
  }
}

Future<String?> resetPassword(String? site, String? email) async {
  if (site == null || site.isEmpty) {
    return 'site-required';
  }
  if (email == null || email.isEmpty) {
    return 'email-required';
  }
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: '${version == "for test" ? testUrl : appUrl}/#/$site',
      ),
    );
    return null;
  } catch (e) {
    debugPrint(e.toString());
    return getAuthErrorCode(e);
  }
}

Future<String?> resetMyPassword(String? site) async {
  final email = FirebaseAuth.instance.currentUser?.email;
  return resetPassword(site, email);
}

bool validatePassword(String password) =>
    password.length >= 8 &&
    ((RegExp(r'[0-9]').hasMatch(password) ? 1 : 0) +
            (RegExp(r'[A-Z]').hasMatch(password) ? 1 : 0) +
            (RegExp(r'[a-z]').hasMatch(password) ? 1 : 0) +
            (RegExp(r'[^0-9A-Za-z]').hasMatch(password) ? 1 : 0)) >=
        3;

String getAuthErrorCode(Object e) => e
    .toString()
    .replaceFirst(RegExp(r'^[^/]*/'), '')
    .replaceFirst(RegExp(r'].*'), '');

Future<void> logout() => FirebaseAuth.instance.signOut();
