import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/data_state.dart';
import 'auth_repository.dart';
import 'firebase_utils.dart';
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
    required String id,
    required DateTime? deletedAt,
  }) = _Account;
}

@freezed
class SiteAccount with _$SiteAccount {
  const factory SiteAccount({
    required String account,
    required String site,
  }) = _SiteAccount;
}

@Riverpod(keepAlive: true)
DataState<SiteAuth> siteAuthRepository(SiteAuthRepositoryRef ref) {
  final DataState<String> site = ref.watch(
    siteRepositoryProvider.select(
      (value) => switch (value) {
        Loading() => const Loading(),
        Error() => Error.fromError(value),
        Success() => Success(data: value.data.$1.id),
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
  DataState<Account> build() {
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
            if (siteAuth.site == null) {
              cancel(next: logout);
            } else {
              if (siteAuth.uid == null) {
                cancel(next: logout);
              } else {
                if ((prev is Success<SiteAuth>) && prev.data == siteAuth) {
                  // Skip
                } else {
                  cancel(
                    state: const Loading<Account>(),
                    next: () => listenAccount(siteAuth),
                  );
                }
              }
            }
          }
        }
      },
    );
    return const Loading<Account>();
  }

  @visibleForTesting
  void listenAccount(SiteAuth siteAuth) {
    debugPrint('''
    info: accountRepository.onSiteAuthChange(siteAuth(
            site: ${siteAuth.site},
            uid: ${siteAuth.uid}
))''');
    _sub = FirebaseFirestore.instance
        .collection('sites')
        .doc(siteAuth.site)
        .collection('accounts')
        .doc(siteAuth.uid)
        .snapshots()
        .listen(
      (doc) {
        if (!isDeleted(doc)) {
          state = Success(
            data: Account(
              id: doc.id,
              deletedAt: getDateTimeValue(doc, "deletedAt"),
            ),
          );
        } else {
          cancel(next: logout);
        }
      },
      onError: (error, stackTrace) {
        cancel(
          state: Error(error: error, stackTrace: stackTrace),
          next: logout,
        );
      },
    );
  }

  Future<void> cancel({
    DataState<Account> state = const Loading<Account>(),
    required void Function() next,
  }) async {
    debugPrint('''
    info: accountRepository.cancel(
            state: ${state.runtimeType.toString()},
            next: ${next.runtimeType}
)''');
    await _sub?.cancel();
    _sub = null;
    if (this.state != state) {
      this.state = state;
    }
    await Future.delayed(const Duration(milliseconds: 100));
    next();
  }
}

@Riverpod(keepAlive: true)
DataState<SiteAccount> siteAccountRepository(SiteAccountRepositoryRef ref) {
  final DataState<String> site = ref.watch(
    siteRepositoryProvider.select(
      (value) => switch (value) {
        Loading() => const Loading(),
        Error() => Error.fromError(value),
        Success() => Success(data: value.data.$1.id),
      },
    ),
  );
  final DataState<String> account = ref.watch(
    accountRepositoryProvider.select(
      (value) => switch (value) {
        Loading() => const Loading(),
        Error() => Error.fromError(value),
        Success() => Success(data: value.data.id),
      },
    ),
  );
  return switch (site) {
    Loading() => const Loading(),
    Error() => Error.fromError(site),
    Success() => switch (account) {
        Loading() => const Loading(),
        Error() => Error.fromError(account),
        Success() => Success(
            data: SiteAccount(
              account: account.data,
              site: site.data,
            ),
          ),
      }
  };
}
