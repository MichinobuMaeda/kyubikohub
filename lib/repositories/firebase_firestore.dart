import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user.dart';
import 'firebase_auth.dart';
import 'org_repository.dart';

part 'firebase_firestore.g.dart';
part 'firebase_firestore.freezed.dart';

@freezed
class Conf with _$Conf {
  const factory Conf({
    required String? uiVersion,
    required String? policy,
  }) = _Conf;
}

@freezed
class Account with _$Account {
  const factory Account({
    required String org,
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

@Riverpod(keepAlive: true)
Stream<Conf> conf(ConfRef ref) => FirebaseFirestore.instance
    .collection('service')
    .doc('conf')
    .snapshots()
    .map(
      (doc) => Conf(
        uiVersion: getStringValue(doc, "uiVersion"),
        policy: getStringValue(doc, "policy"),
      ),
    );

DocumentReference<Map<String, dynamic>> orgRef(String org) =>
    FirebaseFirestore.instance.collection('orgs').doc(org);

@Riverpod(keepAlive: true)
Stream<Account> myAccount(MyAccountRef ref) =>
    ref.watch(firebaseAuthProvider).when(
          data: (authUser) => authUser == null
              ? const Stream.empty()
              : ref.watch(orgRepositoryProvider).when(
                    data: (org) => orgRef(org)
                        .collection('accounts')
                        .doc(authUser.uid)
                        .snapshots()
                        .where((doc) => doc.exists)
                        .where((doc) => !isDeleted(doc))
                        .map((doc) => Account(org: org, user: doc.get('user'))),
                    error: (error, stackTrace) => const Stream.empty(),
                    loading: () => const Stream.empty(),
                  ),
          error: (error, stackTrace) => const Stream.empty(),
          loading: () => const Stream.empty(),
        );

@Riverpod(keepAlive: true)
Stream<List<User>> users(UsersRef ref) => ref.watch(myAccountProvider).when(
      data: (myAccount) =>
          orgRef(myAccount.org).collection('users').snapshots().map(
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
