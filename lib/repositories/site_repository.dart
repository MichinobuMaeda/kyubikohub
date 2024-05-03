import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_firestore.dart';
import '../providers/data_state.dart';

part 'site_repository.g.dart';
part 'site_repository.freezed.dart';

@freezed
class Site with _$Site {
  const factory Site({
    required String id,
    required String name,
    required String desc,
  }) = _Site;
}

@Riverpod(keepAlive: true)
class SiteRepository extends _$SiteRepository {
  StreamSubscription? _sub;
  String? _id;
  SharedPreferences? _prefs;

  @override
  DataState<Site> build() {
    initState();
    return Loading();
  }

  @visibleForTesting
  Future<void> initState() async {
    _prefs = _prefs ?? await SharedPreferences.getInstance();
    final id = _prefs!.getString('site');
    if (id == null) {
      return;
    }
    onSiteChange(id);
  }

  @visibleForTesting
  Future<void> saveSiteId(String id) async {
    _prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs!.setString('site', id);
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

    await _sub?.cancel();
    _sub = ref.snapshots().listen(
      (doc) {
        if (doc.exists) {
          state = Success(
            Site(
              id: id,
              name: getStringValue(doc, 'name') ?? '-',
              desc: getStringValue(doc, 'desc') ?? '',
            ),
          );
          _id = id;
          saveSiteId(id);
        } else {
          state = Loading();
        }
      },
      onError: (error, stackTrace) {
        state = Error(error, stackTrace);
      },
    );
  }
}
