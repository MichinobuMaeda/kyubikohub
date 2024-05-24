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
  String? build() => null;

  Future<String?> onSiteParamChanged(String? next) async {
    final localStorage = ref.read(localStorageRepositoryProvider);
    if (state == next) {
      // Nothing to do
    } else {
      debugPrint('INFO    : onSiteParamChanged $state --> $next');
      if (next == null) {
        final savedSite = localStorage!.getString(LocalStorageKey.site.name);
        if (savedSite != null) {
          debugPrint('INFO    : onSiteParamChanged Saved: $savedSite');
          return savedSite;
        }
      } else {
        final doc = await colSiteRef.doc(next).get();
        if (!isDeleted(doc)) {
          state = next;
          localStorage!.setString(LocalStorageKey.site.name, next);
        }
      }
    }
    return state;
  }
}

@Riverpod(keepAlive: true)
class SiteRepository extends _$SiteRepository {
  StreamSubscription? _sub;

  @override
  DataState<(Site, List<Site>)> build() {
    ref.listen(
      siteParamRepositoryProvider,
      fireImmediately: true,
      (prev, next) {
        debugPrint('''
INFO    : listen(siteParamRepositoryProvider, (
    $prev,
    $next) {})''');
        if (prev != next && next != null) {
          onSiteChanged(next);
        }
      },
    );
    return const Loading();
  }

  Site fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) => Site(
        id: doc.id,
        name: getStringValue(doc, 'name') ?? '-',
        forGuests: getStringValue(doc, 'forGuests') ?? '',
        forMembers: getStringValue(doc, 'forMembers') ?? '',
        forMangers: getStringValue(doc, 'forMangers') ?? '',
        deleted: isDeleted(doc),
      );

  @visibleForTesting
  Future<void> onSiteChanged(String next) async {
    await _sub?.cancel();
    if (next == 'admins') {
      _sub = colSiteRef.snapshots().listen(
        (snap) {
          snap.docs;
          final doc = snap.docs.singleWhere((item) => item.id == next);
          if (!isDeleted(doc)) {
            final site = fromDoc(doc);
            final sites = snap.docs
                .map(
                  (doc) => fromDoc(doc),
                )
                .toList();
            state = Success(data: (site, sites));
          } else {
            state = const Loading();
          }
        },
        onError: (error, stackTrace) {
          state = Error(error: error, stackTrace: stackTrace);
        },
      );
    } else {
      _sub = colSiteRef.doc(next).snapshots().listen(
        (doc) {
          if (!isDeleted(doc)) {
            final site = fromDoc(doc);
            state = Success(data: (site, [site]));
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
}
