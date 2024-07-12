import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config.dart';
import '../models/data_state.dart';
import '../models/notice.dart';
import 'firebase_utils.dart';
import 'account_repository.dart';

part 'notices_repository.g.dart';

@Riverpod(keepAlive: true)
class NoticesRepository extends _$NoticesRepository {
  StreamSubscription? _sub;

  @override
  List<Notice> build() {
    ref.listen(
      accountRepositoryProvider,
      fireImmediately: true,
      (prev, next) {
        debugPrint('INFO    : NoticesRepository.build next: $next');
        if ((next is Success<Account?>) && next.data != null) {
          listen(next.data!);
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
        .collection('notices')
        .orderBy('createdAt', descending: true)
        .limit(noticesLimit)
        .snapshots()
        .listen(
      (snap) {
        final groups = List<Notice>.from((state as List<Notice>?) ?? []);
        for (var docChange in snap.docChanges) {
          if (docChange.type == DocumentChangeType.modified ||
              docChange.type == DocumentChangeType.removed) {
            groups.removeWhere((notice) => notice.id == docChange.doc.id);
          }
          if (docChange.type == DocumentChangeType.modified ||
              docChange.type == DocumentChangeType.added) {
            groups.add(
              Notice(
                id: docChange.doc.id,
                title: getStringValue(docChange.doc, 'title') ?? '',
                message: getStringValue(docChange.doc, 'message') ?? '',
                note: getStringValue(docChange.doc, 'note'),
                createdAt: getDateTimeValue(docChange.doc, 'createdAt') ??
                    DateTime(2000),
                updatedAt: getDateTimeValue(docChange.doc, 'updatedAt'),
                deletedAt: getDateTimeValue(docChange.doc, 'deletedAt'),
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

  @visibleForTesting
  Future<void> cancel() async {
    await _sub?.cancel();
    _sub = null;
    state = [];
  }
}
