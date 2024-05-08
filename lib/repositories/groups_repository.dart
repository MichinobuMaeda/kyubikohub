import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/data_state.dart';
import 'firebase_firestore.dart';
import 'account_repository.dart';
import 'site_repository.dart';

part 'groups_repository.g.dart';
part 'groups_repository.freezed.dart';

@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    required List<String> users,
    required DateTime? deletedAt,
  }) = _Group;
}

@Riverpod(keepAlive: true)
class GroupsRepository extends _$GroupsRepository {
  StreamSubscription? _sub;

  @override
  List<Group> build() {
    final account = ref.watch(accountRepositoryProvider);
    if (account is Success<Account>) {
      final site = ref.watch(siteRepositoryProvider);
      if (site is Success<Site>) {
        final groupsRef = FirebaseFirestore.instance
            .collection('sites')
            .doc(site.data.id)
            .collection('groups');
        _sub?.cancel();
        _sub = groupsRef.snapshots().listen(
          (snap) {
            final groups = List<Group>.from(state);
            for (var docChange in snap.docChanges) {
              if (docChange.type == DocumentChangeType.modified ||
                  docChange.type == DocumentChangeType.removed) {
                groups.removeWhere((user) => user.id == docChange.doc.id);
              }
              if (docChange.type == DocumentChangeType.modified ||
                  docChange.type == DocumentChangeType.added) {
                groups.add(
                  Group(
                    id: docChange.doc.id,
                    name: getStringValue(docChange.doc, "name") ?? '',
                    users: getStringList(docChange.doc, "users"),
                    deletedAt: getDateTimeValue(docChange.doc, "deletedAt"),
                  ),
                );
              }
            }
            state = groups;
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
