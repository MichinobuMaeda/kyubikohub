import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/data_state.dart';
import 'firebase_firestore.dart';
import 'account_repository.dart';
import 'site_repository.dart';

part 'users_repository.g.dart';
part 'users_repository.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String? email,
    required DateTime? deletedAt,
  }) = _User;
}

@Riverpod(keepAlive: true)
class UsersRepository extends _$UsersRepository {
  StreamSubscription? _sub;

  @override
  List<User> build() {
    final account = ref.watch(accountRepositoryProvider);
    if (account is Success<Account>) {
      final site = ref.watch(siteRepositoryProvider);
      if (site is Success<Site>) {
        final usersRef = FirebaseFirestore.instance
            .collection('sites')
            .doc(site.data.id)
            .collection('users');
        _sub?.cancel();
        _sub = usersRef.snapshots().listen(
          (snap) {
            final users = List<User>.from(state);
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
                    name: getStringValue(docChange.doc, "name") ?? '',
                    email: getStringValue(docChange.doc, "email"),
                    deletedAt: getDateTimeValue(docChange.doc, "deletedAt"),
                  ),
                );
              }
            }
            state = users;
          },
          onError: (error, stackTrace) {
            _sub?.cancel();
            state = [];
          },
        );
      } else {
        _sub?.cancel();
        state = [];
      }
    } else {
      _sub?.cancel();
      state = [];
    }
    return [];
  }
}
