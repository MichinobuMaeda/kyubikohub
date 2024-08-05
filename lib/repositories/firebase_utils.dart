import 'package:cloud_firestore/cloud_firestore.dart';

String? getStringValue(
  DocumentSnapshot<Map<String, dynamic>> doc,
  String key,
) =>
    (doc.exists &&
            doc.data()?.containsKey(key) == true &&
            doc.get(key) is String)
        ? doc.get(key)
        : null;

DateTime? getDateTimeValue(
  DocumentSnapshot<Map<String, dynamic>> doc,
  String key,
) =>
    (doc.exists &&
            doc.data()?.containsKey(key) == true &&
            doc.get(key) is Timestamp)
        ? (doc.get(key) as Timestamp).toDate()
        : null;

List<String?> getStringList(
  DocumentSnapshot<Map<String, dynamic>> doc,
  String key,
) =>
    (doc.exists &&
            doc.data()?.containsKey(key) == true &&
            doc.get(key) is List<dynamic>)
        ? (doc.get(key) as List<dynamic>)
            .map<String?>((item) => (item is String) ? item : null)
            .toList()
        : [];

bool isDeleted(
  DocumentSnapshot<Map<String, dynamic>> doc,
) =>
    (!doc.exists) ||
    (doc.data()?.containsKey('deletedAt') == true &&
        doc.get('deletedAt') != null);
