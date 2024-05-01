import 'dart:async';

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
    required String guide,
    required String policy,
  }) = _Site;
}

@Riverpod(keepAlive: true)
class SiteRepository extends _$SiteRepository {
  StreamSubscription? _sub;
  String? id;

  @override
  Future<DataState<Site>> build() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('site');
    if (id != null) {
      listen();
    }
    return Loading();
  }

  Future<void> onSiteChange(String id) async {
    if (this.id != id) {
      await cancel();
      this.id = id;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('site', id);
      listen();
    }
  }

  @visibleForTesting
  Future<void> listen() async {
    final ref = FirebaseFirestore.instance.collection('sites').doc(id);
    _sub = ref.snapshots().listen(
      (doc) {
        state = AsyncData(
          Success(
            Site(
              id: id!,
              name: getStringValue(doc, "name") ?? '-',
              guide: getStringValue(doc, "guide") ?? '',
              policy: getStringValue(doc, "policy") ?? '',
            ),
          ),
        );
      },
      onError: (error, stackTrace) {
        state = AsyncData(Error(error, stackTrace));
      },
    );
  }

  @visibleForTesting
  Future<void> cancel() async {
    await _sub?.cancel();
    _sub = null;
    state = AsyncData(Loading());
  }
}
