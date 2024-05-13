import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/data_state.dart';
import '../models/group.dart';
import 'firebase_utils.dart';
import 'account_repository.dart';

part 'groups_repository.g.dart';

@Riverpod(keepAlive: true)
class GroupsRepository extends _$GroupsRepository {
  StreamSubscription? _sub;

  @override
  List<Group> build() {
    ref.listen(
      siteAccountRepositoryProvider,
      fireImmediately: true,
      (prev, next) {
        debugPrint('    info: GroupsRepository.build next: $next');
        if (next is Success) {
          listen((next as Success).data);
        } else {
          cancel();
        }
      },
    );
    return [];
  }

  Future<void> listen(SiteAccount siteAccount) async {
    await _sub?.cancel();
    _sub = FirebaseFirestore.instance
        .collection('sites')
        .doc(siteAccount.site)
        .collection('groups')
        .snapshots()
        .listen(
      (snap) {
        final groups = List<Group>.from((state as List<Group>?) ?? []);
        for (var docChange in snap.docChanges) {
          if (docChange.type == DocumentChangeType.modified ||
              docChange.type == DocumentChangeType.removed) {
            groups.removeWhere((group) => group.id == docChange.doc.id);
          }
          if (docChange.type == DocumentChangeType.modified ||
              docChange.type == DocumentChangeType.added) {
            groups.add(
              Group(
                id: docChange.doc.id,
                name: getStringValue(docChange.doc, "name") ?? '',
                users: getStringList(docChange.doc, "users")
                    .whereType<String>()
                    .toList(),
                deletedAt: getDateTimeValue(docChange.doc, "deletedAt"),
              ),
            );
          }
        }
        state = groups;
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
