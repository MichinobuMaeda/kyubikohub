import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/log.dart';

Future<void> logAppError(String message) =>
    setLog(null, LogLevel.error, message);

Future<void> logAppWarn(String? user, String message) =>
    setLog(null, LogLevel.warn, message);

Future<void> logAppInfo(String message) => setLog(null, LogLevel.info, message);

Future<void> logError(String? site, String message) =>
    setLog(site, LogLevel.error, message);

Future<void> logWarn(String? site, String message) =>
    setLog(site, LogLevel.warn, message);

Future<void> logInfo(String? site, String message) =>
    setLog(site, LogLevel.info, message);

@visibleForTesting
Future<void> setLog(
  String? site,
  LogLevel level,
  String message,
) async {
  try {
    final ts = DateTime.now();
    final colRef = site == null
        ? FirebaseFirestore.instance.collection('logs')
        : FirebaseFirestore.instance
            .collection('sites')
            .doc(site)
            .collection('logs');
    colRef.doc(ts.toIso8601String().replaceAll(RegExp(r'[^0-9]'), '')).set({
      'ts': ts,
      'level': level.value,
      'user': FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
      'message': message,
    });
  } catch (e, s) {
    debugPrint('ERROR   : $e\n${s.toString()}');
  }
}
