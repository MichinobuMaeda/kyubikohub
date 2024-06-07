import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/data_state.dart';
import '../models/conf.dart';
import 'firebase_utils.dart';

part 'conf_repository.g.dart';

@Riverpod(keepAlive: true)
class ConfRepository extends _$ConfRepository {
  @override
  DataState<Conf> build() {
    FirebaseFirestore.instance
        .collection('service')
        .doc('conf')
        .snapshots()
        .listen((doc) {
      try {
        if (!doc.exists) {
          throw 'Error: missed service/conf';
        }
        state = Success(
          data: Conf(
            uiVersion: getStringValue(doc, "uiVersion"),
            desc: getStringValue(doc, "desc"),
            forGuests: getStringValue(doc, "forGuests"),
            forMembers: getStringValue(doc, "forMembers"),
            forMangers: getStringValue(doc, "forMangers"),

          ),
        );
      } catch (e, s) {
        state = Error(error: e, stackTrace: s);
      }
    });
    return const Loading();
  }
}
