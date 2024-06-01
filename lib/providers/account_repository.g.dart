// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$siteAuthRepositoryHash() =>
    r'c8b267753ce98a1103074fc435b18a97cc9a735d';

/// See also [siteAuthRepository].
@ProviderFor(siteAuthRepository)
final siteAuthRepositoryProvider = Provider<DataState<SiteAuth>>.internal(
  siteAuthRepository,
  name: r'siteAuthRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$siteAuthRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SiteAuthRepositoryRef = ProviderRef<DataState<SiteAuth>>;
String _$accountStatusHash() => r'489a93d6a5316e7512a8a9a472b85b3ba25f03f1';

/// See also [accountStatus].
@ProviderFor(accountStatus)
final accountStatusProvider = Provider<AccountStatus>.internal(
  accountStatus,
  name: r'accountStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AccountStatusRef = ProviderRef<AccountStatus>;
String _$accountRepositoryHash() => r'f7ad2220ec7c219e09813dc38c08e4d86c6bee40';

/// See also [AccountRepository].
@ProviderFor(AccountRepository)
final accountRepositoryProvider =
    NotifierProvider<AccountRepository, DataState<Account?>>.internal(
  AccountRepository.new,
  name: r'accountRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountRepository = Notifier<DataState<Account?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
