// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_firestore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myAccountHash() => r'2b804f7f5e32cb09a90c3735dfceca8b8863b0ba';

/// See also [myAccount].
@ProviderFor(myAccount)
final myAccountProvider = StreamProvider<Account>.internal(
  myAccount,
  name: r'myAccountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myAccountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyAccountRef = StreamProviderRef<Account>;
String _$usersHash() => r'3a61d03c64e657e4a4f61c063554d96bd9f6b94c';

/// See also [users].
@ProviderFor(users)
final usersProvider = StreamProvider<List<User>>.internal(
  users,
  name: r'usersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$usersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UsersRef = StreamProviderRef<List<User>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
