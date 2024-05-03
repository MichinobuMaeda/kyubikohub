// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthRepositoryHash() =>
    r'281f7a04051f1470b7a71b90adee5b3f8a4c5408';

/// See also [FirebaseAuthRepository].
@ProviderFor(FirebaseAuthRepository)
final firebaseAuthRepositoryProvider =
    NotifierProvider<FirebaseAuthRepository, DataState<AuthUser?>>.internal(
  FirebaseAuthRepository.new,
  name: r'firebaseAuthRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseAuthRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FirebaseAuthRepository = Notifier<DataState<AuthUser?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
