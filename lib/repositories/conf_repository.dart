import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/data_state.dart';
import 'firebase_firestore.dart';

part 'conf_repository.g.dart';
part 'conf_repository.freezed.dart';

@freezed
class Conf with _$Conf {
  const factory Conf({
    required String? uiVersion,
    required String? desc,
  }) = _Conf;
}

@Riverpod(keepAlive: true)
class ConfRepository extends _$ConfRepository {
  @override
  Future<DataState<Conf>> build() async {
    final ref = FirebaseFirestore.instance.collection('service').doc('conf');
    ref.snapshots().listen(
      (doc) {
        state = AsyncData(
          Success(
            Conf(
              uiVersion: getStringValue(doc, "uiVersion"),
              desc: getStringValue(doc, "desc"),
            ),
          ),
        );
      },
      onError: (error, stackTrace) => Error(error, stackTrace),
    );
    return Loading();
  }
}
