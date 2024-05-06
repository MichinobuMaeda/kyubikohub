import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

final _confRef = FirebaseFirestore.instance.collection('service').doc('conf');

@Riverpod(keepAlive: true)
Stream<Conf?> confRepository(ConfRepositoryRef ref) =>
    _confRef.snapshots()
        .map(
          (doc) => doc.exists
              ? Conf(
                  uiVersion: getStringValue(doc, "uiVersion"),
                  desc: getStringValue(doc, "desc"),
                )
              : null,
        );
