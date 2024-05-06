import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_firestore.dart';
import '../models/data_state.dart';
import 'local_storage_repository.dart';

part 'site_repository.g.dart';
part 'site_repository.freezed.dart';

@freezed
class Site with _$Site {
  const factory Site({
    required String id,
    required String name,
    required String forGuests,
    required String forMembers,
    required String forMangers,
  }) = _Site;
}

@Riverpod(keepAlive: true)
class SiteRepository extends _$SiteRepository {
  StreamSubscription? _sub;

  @override
  DataState<Site> build() => const Loading();

  @visibleForTesting
  Future<void> saveSiteId(String id) async {
    final localStorage = ref.watch(localStorageRepositoryProvider);
    await localStorage!.setString(LocalStorageKey.site.name, id);
  }

  Future<void> onSiteChange(String? id) async {
    final localStorage = ref.watch(localStorageRepositoryProvider);
    final colRef = FirebaseFirestore.instance.collection('sites');

    if (state is Loading) {
      final initialId = localStorage!.getString(LocalStorageKey.site.name);
      if (initialId != null && initialId.isNotEmpty) {
        final doc = await colRef.doc(initialId).get();
        if (doc.exists) {
          setSite(localStorage, doc);
        }
      }
    }

    if (id == null ||
        id.isEmpty ||
        (state is Success && (state as Success<Site>).data.id == id)) {
      return;
    }

    final docRef = colRef.doc(id);
    final doc = await docRef.get();

    if (!doc.exists) {
      return;
    }

    setSite(localStorage!, doc);

    await _sub?.cancel();
    _sub = docRef.snapshots().listen(
      (doc) {
        if (doc.exists) {
          setSite(localStorage, doc);
        } else {
          state = const Loading();
        }
      },
      onError: (error, stackTrace) {
        state = Error(error: error, stackTrace: stackTrace);
      },
    );
  }

  void setSite(SharedPreferences localStorage, DocumentSnapshot<Map<String, dynamic>> doc) {
    final site = Success(
      data: Site(
        id: doc.id,
        name: getStringValue(doc, 'name') ?? '-',
        forGuests: getStringValue(doc, 'forGuests') ?? '',
        forMembers: getStringValue(doc, 'forMembers') ?? '',
        forMangers: getStringValue(doc, 'forMangers') ?? '',
      ),
    );

    if (state == site) {
      return;
    }

    state = site;
    localStorage.setString(LocalStorageKey.site.name, doc.id);
  }
}
