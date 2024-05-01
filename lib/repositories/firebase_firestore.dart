import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user.dart';
import '../providers/data_state.dart';
import 'firebase_auth.dart';
import 'site_repository.dart';

part 'firebase_firestore.g.dart';
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

bool isDeleted(
  DocumentSnapshot<Map<String, dynamic>> doc,
) =>
    (!doc.exists) ||
    (doc.data()?.containsKey('deletedAt') == true &&
        doc.get('deletedAt') != null);

DocumentReference<Map<String, dynamic>> siteRef(String id) =>
    FirebaseFirestore.instance.collection('sites').doc(id);

@Riverpod(keepAlive: true)
Stream<Account> myAccount(MyAccountRef ref) =>
    ref.watch(firebaseAuthRepositoryProvider).when(
          data: (authUser) => switch (authUser) {
            Loading() => const Stream.empty(),
            Error() => const Stream.empty(),
            Success() => authUser.data == null
                ? const Stream.empty()
                : ref.watch(siteRepositoryProvider).when(
                      data: (DataState<Site> site) => switch (site) {
                        Loading() => const Stream.empty(),
                        Error() => const Stream.empty(),
                        Success() => siteRef(site.data.id)
                            .collection('accounts')
                            .doc(authUser.data!.uid)
                            .snapshots()
                            .where((doc) => doc.exists)
                            .where((doc) => !isDeleted(doc))
                            .map(
                              (doc) => Account(
                                site: site.data.id,
                                user: doc.get('user'),
                              ),
                            ),
                      },
                      error: (error, stackTrace) => const Stream.empty(),
                      loading: () => const Stream.empty(),
                    ),
          },
          error: (error, stackTrace) => const Stream.empty(),
          loading: () => const Stream.empty(),
        );

@Riverpod(keepAlive: true)
Stream<List<User>> users(UsersRef ref) => ref.watch(myAccountProvider).when(
      data: (myAccount) =>
          siteRef(myAccount.site).collection('users').snapshots().map(
                (snapshot) => snapshot.docs
                    .map(
                      (doc) => User(
                        id: doc.id,
                        name: getStringValue(doc, "name") ?? '',
                      ),
                    )
                    .toList(),
              ),
      error: (error, stackTrace) => const Stream.empty(),
      loading: () => const Stream.empty(),
    );
