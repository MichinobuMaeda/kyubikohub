import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_firestore.freezed.dart';

@freezed
class Account with _$Account {
  const factory Account({
    required String site,
    required String user,
  }) = _Account;
}

String? getStringValue(
  DocumentSnapshot<Map<String, dynamic>> doc,
  String key,
) =>
    (doc.exists && doc.data()?.containsKey(key) != null)
        ? doc.data()![key]
        : null;

DateTime? getDateTimeValue(
  DocumentSnapshot<Map<String, dynamic>> doc,
  String key,
) =>
    (doc.exists && doc.data()?.containsKey(key) != null)
        ? (doc.data()![key] as Timestamp).toDate()
        : null;

bool isDeleted(
  DocumentSnapshot<Map<String, dynamic>> doc,
) =>
    (!doc.exists) ||
    (doc.data()?.containsKey('deletedAt') == true &&
        doc.get('deletedAt') != null);

DocumentReference<Map<String, dynamic>> siteRef(String id) =>
    FirebaseFirestore.instance.collection('sites').doc(id);
