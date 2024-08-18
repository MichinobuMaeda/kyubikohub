import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../config.dart';

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

Future<String> loginWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  if (email.isEmpty) {
    return 'email-required';
  } else if (password.isEmpty) {
    return 'password-required';
  }
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return 'ok';
  } catch (e) {
    debugPrint(e.toString());
    return getAuthErrorCode(e);
  }
}

Future<String> changePassword({
  required String curPassword,
  required String newPassword,
  required String conPassword,
}) async {
  final email = FirebaseAuth.instance.currentUser?.email;
  if (email == null || email.isEmpty) {
    return 'email-required';
  } else if (curPassword.isEmpty) {
    return 'curPassword-required';
  } else if (newPassword.isEmpty) {
    return 'newPassword-required';
  } else if (conPassword.isEmpty) {
    return 'conPassword-required';
  } else if (newPassword != conPassword) {
    return 'password-mismatch';
  } else if (!validatePassword(newPassword)) {
    return 'weak-password';
  }
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: curPassword,
    );
  } catch (e) {
    debugPrint(e.toString());
    return getAuthErrorCode(e);
  }
  try {
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    return 'ok';
  } catch (e) {
    debugPrint(e.toString());
    return getAuthErrorCode(e);
  }
}

Future<String> resetPassword(String? site, String? email) async {
  if (site == null || site.isEmpty) {
    return 'site-required';
  }
  if (email == null || email.isEmpty) {
    return 'email-required';
  }
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: '${version == "for test" ? testUrl : appUrl}/#/$site',
      ),
    );
    return 'ok';
  } catch (e) {
    debugPrint(e.toString());
    return getAuthErrorCode(e);
  }
}

Future<String?> resetMyPassword(String? site) =>
    resetPassword(site, getUserEmail());

bool validatePassword(String password) =>
    password.length >= 8 &&
    ((RegExp(r'[0-9]').hasMatch(password) ? 1 : 0) +
            (RegExp(r'[A-Z]').hasMatch(password) ? 1 : 0) +
            (RegExp(r'[a-z]').hasMatch(password) ? 1 : 0) +
            (RegExp(r'[^0-9A-Za-z]').hasMatch(password) ? 1 : 0)) >=
        3;

String getAuthErrorCode(Object e) => e
    .toString()
    .replaceFirst(RegExp(r'^[^/]*/'), '')
    .replaceFirst(RegExp(r'].*'), '');

String? getUserEmail() => FirebaseAuth.instance.currentUser?.email;

Future<void> logout() => FirebaseAuth.instance.signOut();
