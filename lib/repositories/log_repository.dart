import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'firebase_utils.dart';

part 'log_repository.freezed.dart';

enum LogLevel {
  error('error'),
  warn('warn'),
  info('info');

  final String value;
  const LogLevel(this.value);
}

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

@freezed
class Log with _$Log {
  const factory Log({
    required DateTime ts,
    required LogLevel level,
    required String user,
    required String message,
  }) = _Log;
}

DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

Future<List<Log>> getLog(String? site, DateTime date) async {
  return (await (site == null
              ? FirebaseFirestore.instance.collection('logs')
              : FirebaseFirestore.instance
                  .collection('sites')
                  .doc(site)
                  .collection('logs'))
          .where('ts', isGreaterThanOrEqualTo: date)
          .where('ts', isLessThan: date.add(const Duration(days: 1)))
          .orderBy('ts', descending: true)
          .get())
      .docs
      .map(
        (doc) => Log(
          ts: getDateTimeValue(doc, 'ts') ?? DateTime(1970),
          level: LogLevel.values.any(
            (v) => v.value == getStringValue(doc, 'user'),
          )
              ? LogLevel.values.singleWhere(
                  (v) => v.value == getStringValue(doc, 'user'),
                )
              : LogLevel.error,
          user: getStringValue(doc, 'user') ?? '',
          message: getStringValue(doc, 'message') ?? '',
        ),
      )
      .toList();
}
