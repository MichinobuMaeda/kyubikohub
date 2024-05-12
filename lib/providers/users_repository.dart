import 'dart:async';
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
      siteAccountRepositoryProvider,
      fireImmediately: true,
      (prev, next) {
        if (next is Success<SiteAccount>) {
          if (prev == next) {
            // skip
          } else {
            listen(next.data.site);
          }
        } else {
          cancel();
        }
      },
    );
    return [];
  }

  Future<void> listen(String site) async {
    await _sub?.cancel();
    FirebaseFirestore.instance
        .collection('sites')
        .doc(site)
        .collection('users')
        .snapshots()
        .listen(
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
                email: getStringValue(docChange.doc, "email") ?? '',
                deletedAt: getDateTimeValue(docChange.doc, "deletedAt"),
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

  Future<void> cancel() async {
    await _sub?.cancel();
    _sub = null;
    state = [];
  }
}
