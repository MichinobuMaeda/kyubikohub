import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kyubikohub/config.dart';
import 'package:kyubikohub/providers/groups_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/data_state.dart';
import '../repositories/firebase_utils.dart';
import '../repositories/firebase_repository.dart';
import 'site_repository.dart';

part 'account_repository.g.dart';
part 'account_repository.freezed.dart';

@freezed
class SiteAuth with _$SiteAuth {
  const factory SiteAuth({
    required String? site,
    required String? uid,
  }) = _SiteAuth;
}

@freezed
class Account with _$Account {
  const factory Account({
    required String site,
    required String id,
    required String? user,
    required DateTime? deletedAt,
  }) = _Account;
}

@freezed
class AccountStatus with _$AccountStatus {
  const factory AccountStatus({
    required Account? account,
    required bool manager,
    required bool admin,
  }) = _AccountStatus;
}

@Riverpod(keepAlive: true)
DataState<SiteAuth> siteAuthRepository(SiteAuthRepositoryRef ref) {
  final DataState<String> site = ref.watch(
    siteRepositoryProvider.select(
      (value) => switch (value) {
        Loading() => const Loading(),
        Error() => Error.fromError(value),
        Success() => Success(data: value.data.selected.id),
      },
    ),
  );
  final DataState<String?> uid = ref.watch(
    authRepositoryProvider.select(
      (value) => switch (value) {
        Loading() => const Loading(),
        Error() => Error.fromError(value),
        Success() => Success(data: value.data?.uid),
      },
    ),
  );
  return switch (site) {
    Loading() => const Loading(),
    Error() => Error.fromError(site),
    Success() => switch (uid) {
        Loading() => const Loading(),
        Error() => Error.fromError(uid),
        Success() => Success(
            data: SiteAuth(
              uid: uid.data,
              site: site.data,
            ),
          ),
      }
  };
}

@Riverpod(keepAlive: true)
class AccountRepository extends _$AccountRepository {
  StreamSubscription? _sub;

  @override
  DataState<Account?> build() {
    ref.listen(
      siteAuthRepositoryProvider,
      fireImmediately: true,
      (prev, next) {
        if (next is Loading) {
          state = const Loading();
        } else if (next is Error) {
          state = Error.fromError((next as Error));
        } else {
          final siteAuth = (next as Success<SiteAuth>).data;
          if (prev is! Success || (prev as Success).data != siteAuth) {
            if (siteAuth.site == null || siteAuth.uid == null) {
              cancel(next: logout);
            } else {
              if ((prev is Success<SiteAuth>) && prev.data == siteAuth) {
                // Skip
              } else {
                cancel(
                  next: () => listenAccount(
                    site: siteAuth.site!,
                    uid: siteAuth.uid!,
                  ),
                );
              }
            }
          }
        }
      },
    );
    return const Loading();
  }

  @visibleForTesting
  void listenAccount({required String site, required String uid}) {
    debugPrint('''
INFO    : accountRepository.onSiteAuthChange(site: $site, uid: $uid)''');
    _sub = FirebaseFirestore.instance
        .collection('sites')
        .doc(site)
        .collection('accounts')
        .doc(uid)
        .snapshots()
        .listen(
      (doc) {
        if (!isDeleted(doc)) {
          state = Success(
            data: Account(
              site: site,
              id: doc.id,
              user: getStringValue(doc, "user"),
              deletedAt: getDateTimeValue(doc, "deletedAt"),
            ),
          );
        } else {
          cancel(next: logout);
        }
      },
      onError: (error, stackTrace) {
        cancel(
          state: Error.fromError(error),
          next: logout,
        );
      },
    );
  }

  Future<void> cancel({
    DataState<Account?>? state,
    required void Function() next,
  }) async {
    debugPrint('''
INFO    : accountRepository.cancel(
            state: ${state.runtimeType.toString()},
            next: ${next.runtimeType}
)''');
    await _sub?.cancel();
    _sub = null;

    if (this.state != state) {
      this.state = state ?? const Success<Account?>(data: null);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    next();
  }
}

@Riverpod(keepAlive: true)
AccountStatus accountStatus(AccountStatusRef ref) {
  final account = ref.watch(
    accountRepositoryProvider.select(
      (value) => switch (value) {
        Loading() => null,
        Error() => null,
        Success() => value.data,
      },
    ),
  );
  final manager = account?.user != null &&
      ref.watch(
        groupsRepositoryProvider.select(
          (groups) => groups.any((group) => group.id == managersGroupId)
              ? groups
                  .singleWhere((group) => group.id == managersGroupId)
                  .users
                  .contains(account?.user)
              : false,
        ),
      );
  return AccountStatus(
    account: account,
    manager: manager,
    admin: account?.site == adminsSiteId,
  );
}

@visibleForTesting
@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String uid,
    required String? email,
  }) = _AuthUser;
}

@visibleForTesting
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
        state = Error.fromError(error);
      },
    );
    return const Loading();
  }
}
