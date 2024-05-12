import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'firebase_utils.dart';
import '../models/data_state.dart';
import '../models/site.dart';
import 'local_storage_repository.dart';

part 'site_repository.g.dart';

final colSiteRef = FirebaseFirestore.instance.collection('sites');

@Riverpod(keepAlive: true)
class SiteParamRepository extends _$SiteParamRepository {
  @override
  String? build() {
    restoreState();
    return null;
  }

  @visibleForTesting
  Future<void> restoreState() async {
    final localStorage = ref.watch(localStorageRepositoryProvider);
    final initialId = localStorage!.getString(LocalStorageKey.site.name);
    if (initialId != null) {
      final doc = await colSiteRef.doc(initialId).get();
      if (!isDeleted(doc)) {
        state = initialId;
      }
    }
  }

  Future<String?> onSiteParamChanged(String? next) async {
    if (state != next && next != null) {
      final doc = await colSiteRef.doc(next).get();
      if (!isDeleted(doc)) {
        state = next;
        final localStorage = ref.watch(localStorageRepositoryProvider);
        localStorage!.setString(LocalStorageKey.site.name, next);
      }
    }
    return state;
  }
}

@Riverpod(keepAlive: true)
class SiteRepository extends _$SiteRepository {
  StreamSubscription? _sub;

  @override
  DataState<Site> build() {
    ref.listen(
      siteParamRepositoryProvider,
      fireImmediately: true,
      (prev, next) {
        debugPrint('''
   info: listen(siteParamRepositoryProvider, (
    $prev,
    $next) {})''');
        if (prev != next && next != null) {
          onSiteChanged(next);
        }
      },
    );
    return const Loading();
  }

  @visibleForTesting
  Future<void> onSiteChanged(String next) async {
    await _sub?.cancel();
    _sub = colSiteRef.doc(next).snapshots().listen(
      (doc) {
        if (!isDeleted(doc)) {
          state = Success(
            data: Site(
              id: doc.id,
              name: getStringValue(doc, 'name') ?? '-',
              forGuests: getStringValue(doc, 'forGuests') ?? '',
              forMembers: getStringValue(doc, 'forMembers') ?? '',
              forMangers: getStringValue(doc, 'forMangers') ?? '',
            ),
          );
        } else {
          state = const Loading();
        }
      },
      onError: (error, stackTrace) {
        state = Error(error: error, stackTrace: stackTrace);
      },
    );
  }
}
