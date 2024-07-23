import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../config.dart';

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

Future<void> updateDoc(
  DocumentReference<Map<String, dynamic>> docRef,
  Map<String, dynamic> data,
) async {
  try {
    docRef.update({
      ...data,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  } catch (e, s) {
    debugPrint('ERROR   : $e\n${s.toString()}');
  }
}

Future<void> deleteDoc(
  DocumentReference<Map<String, dynamic>> docRef,
) =>
    docRef.update({"deletedAt": FieldValue.serverTimestamp()});

Future<void> restoreDoc(
  DocumentReference<Map<String, dynamic>> docRef,
) =>
    docRef.update({"deletedAt": null});

final confRef = FirebaseFirestore.instance.collection('service').doc('conf');

DocumentReference<Map<String, dynamic>> siteRef({
  required String id,
}) =>
    FirebaseFirestore.instance.collection('sites').doc(id);

Future<String> subscribe({
        required String site,
        required String name,
        required String email,
        required String tel,
        required String zip,
        required String prefecture,
        required String city,
        required String address1,
        required String address2,
        required String desc,
        required String managerName,
        required String managerEmail,
}) async {
  try {
    final result = await FirebaseFunctions.instanceFor(
      region: functionsRegion,
    ).httpsCallable('subscribe').call(
      {
        "site": site,
        "name": name,
        "email": email,
        "tel": tel,
        "zip": zip,
        "prefecture": prefecture,
        "city": city,
        "address1": address1,
        "address2": address2,
        "desc": desc,
        "managerName": managerName,
        "managerEmail": managerEmail,
      },
    );
    return result.data as String;
  } on FirebaseFunctionsException catch (e, s) {
    debugPrint(e.code);
    debugPrint(e.details);
    debugPrint(e.message);
    debugPrintStack(label: 'ERROR   : ${e.toString()}', stackTrace: s);
    return 'Error';
  } catch (e, s) {
    debugPrintStack(label: 'ERROR   : ${e.toString()}', stackTrace: s);
    return 'Error';
  }
}

Future<bool> createSite({
  required String siteId,
  required String siteName,
  required String email,
  required String name,
  required String password,
}) async {
  try {
    final result = await FirebaseFunctions.instanceFor(
      region: functionsRegion,
    ).httpsCallable('create_site_with_manager').call(
      {
        "site_id": siteId,
        "site_name": siteName,
        "email": email,
        "name": name,
        "password": password,
      },
    );
    return result.data as bool;
  } on FirebaseFunctionsException catch (e, s) {
    debugPrint(e.code);
    debugPrint(e.details);
    debugPrint(e.message);
    debugPrintStack(label: 'ERROR   : ${e.toString()}', stackTrace: s);
    return false;
  } catch (e, s) {
    debugPrintStack(label: 'ERROR   : ${e.toString()}', stackTrace: s);
    return false;
  }
}
