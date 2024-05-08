import 'package:cloud_firestore/cloud_firestore.dart';

String? getStringValue(
  DocumentSnapshot<Map<String, dynamic>> doc,
  String key,
) =>
    (doc.exists && doc.data()?.containsKey(key) == true)
        ? doc.data()![key]
        : null;

DateTime? getDateTimeValue(
  DocumentSnapshot<Map<String, dynamic>> doc,
  String key,
) =>
    (doc.exists && doc.data()?.containsKey(key) == true)
        ? doc.data()![key] == null
            ? null
            : (doc.data()![key] as Timestamp).toDate()
        : null;

List<String> getStringList(
  DocumentSnapshot<Map<String, dynamic>> doc,
  String key,
) =>
    (doc.exists && doc.data()?.containsKey(key) == true)
        ? (doc.data()![key] == null)
            ? []
            : (doc.data()![key] as List<dynamic>)
                .map((item) => item.toString())
                .toList()
        : [];

bool isDeleted(
  DocumentSnapshot<Map<String, dynamic>> doc,
) =>
    (!doc.exists) ||
    (doc.data()?.containsKey('deletedAt') == true &&
        doc.get('deletedAt') != null);

DocumentReference<Map<String, dynamic>> siteRef(String id) =>
    FirebaseFirestore.instance.collection('sites').doc(id);
