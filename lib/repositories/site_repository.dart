import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_firestore.dart';
import '../models/data_state.dart';

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
  String? _id;
  SharedPreferences? _localStorage;

  @override
  DataState<Site> build() {
    initState();
    return const Loading();
  }

  @visibleForTesting
  Future<SharedPreferences> getLocalStorage() async =>
      _localStorage ?? await SharedPreferences.getInstance();

  @visibleForTesting
  Future<void> initState() async {
    final id = (await getLocalStorage()).getString('site');
    if (id == null) {
      return;
    }
    onSiteChange(id);
  }

  @visibleForTesting
  Future<void> saveSiteId(String id) async {
    (await getLocalStorage()).setString('site', id);
  }

  void setSite(DocumentSnapshot<Map<String, dynamic>> doc) {
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

    if (_id != doc.id) {
      _id = doc.id;
      saveSiteId(doc.id);
    }
  }

  Future<void> onSiteChange(String? id) async {
    if (id == null || id.isEmpty || _id == id) {
      return;
    }

    final ref = FirebaseFirestore.instance.collection('sites').doc(id);
    final doc = await ref.get();

    if (!doc.exists) {
      return;
    }

    setSite(doc);

    await _sub?.cancel();
    _sub = ref.snapshots().listen(
      (doc) {
        if (doc.exists) {
          setSite(doc);
        } else {
          state = Loading();
        }
      },
      onError: (error, stackTrace) {
        state = Error(error: error, stackTrace: stackTrace);
      },
    );
  }
}
