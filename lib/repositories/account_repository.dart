import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/data_state.dart';
import 'firebase_firestore.dart';
import 'site_repository.dart';
import 'auth_repository.dart';

part 'account_repository.g.dart';
part 'account_repository.freezed.dart';

@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required DateTime? deletedAt,
  }) = _Account;
}

@Riverpod(keepAlive: true)
class AccountRepository extends _$AccountRepository {
  StreamSubscription? _sub;

  @override
  DataState<Account> build() {
    ref.watch(authRepositoryProvider).whenData(
      (authUser) {
        final site = ref.watch(siteRepositoryProvider);
        if (site is Success) {
          onAuthUserChanged((site as Success).data, authUser);
        }
      },
    );
    return const Loading();
  }

  DataState<Account> onAuthUserChanged(
    Site site,
    AuthUser? authUser,
  ) {
    final siteRef = FirebaseFirestore.instance.collection('sites').doc(site.id);

    if (authUser == null) {
      cancel();
      return const Loading();
    } else if (state is Success && (state as Success).data.id == authUser.uid) {
      return state;
    } else {
      final docRef = siteRef.collection('accounts').doc(authUser.uid);
      _sub?.cancel();
      _sub = docRef.snapshots().listen(
        (doc) {
          if (doc.exists && !isDeleted(doc)) {
            state = Success(
              data: Account(
                id: doc.id,
                deletedAt: getDateTimeValue(doc, "deletedAt"),
              ),
            );
          } else {
            cancel();
          }
        },
      );
      return state;
    }
  }

  @visibleForTesting
  Future<void> cancel() async {
    await _sub?.cancel();
    _sub = null;
    if (state is! Loading) {
      state = const Loading();
    }
    await FirebaseAuth.instance.signOut();
  }
}
