import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/data_state.dart';
import '../models/user.dart';
import 'firebase_utils.dart';
import 'account_repository.dart';

part 'users_repository.g.dart';

@Riverpod(keepAlive: true)
class UsersRepository extends _$UsersRepository {
  StreamSubscription? _sub;

  @override
  List<User> build() {
    ref.listen(
      accountRepositoryProvider,
      fireImmediately: true,
      (prev, next) {
        debugPrint('INFO    : UsersRepository.build next: $next');
        if (next is Success) {
          listen((next as Success).data);
        } else {
          cancel();
        }
      },
    );
    return [];
  }

  @visibleForTesting
  Future<void> listen(Account account) async {
    await _sub?.cancel();
    _sub = FirebaseFirestore.instance
        .collection('sites')
        .doc(account.site)
        .collection('users')
        .snapshots()
        .listen(
      (snap) {
        final users = List<User>.from((state as List<User>?) ?? []);
        for (var docChange in snap.docChanges) {
          if (docChange.type == DocumentChangeType.modified ||
              docChange.type == DocumentChangeType.removed) {
            users.removeWhere((user) => user.id == docChange.doc.id);
          }
          if (docChange.type == DocumentChangeType.modified ||
              docChange.type == DocumentChangeType.added) {
            users.add(
              User(
                id: docChange.doc.id,
                name: getStringValue(docChange.doc, 'name') ?? '',
                email: getStringValue(docChange.doc, 'email') ?? '',
                deletedAt: getDateTimeValue(docChange.doc, 'deletedAt'),
              ),
            );
          }
        }
        state = users;
      },
      onError: (error, stackTrace) {
        cancel();
      },
    );
  }

  @visibleForTesting
  Future<void> cancel() async {
    await _sub?.cancel();
    _sub = null;
    state = [];
  }
}
