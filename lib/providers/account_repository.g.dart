// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$siteAuthRepositoryHash() =>
    r'8153342eca61d57a2a3f0c6f7caadecf7e665d8e';

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
String _$siteAccountRepositoryHash() =>
    r'0c033ed5d469a427458588b10013406f450f83a3';

/// See also [siteAccountRepository].
@ProviderFor(siteAccountRepository)
final siteAccountRepositoryProvider = Provider<DataState<SiteAccount>>.internal(
  siteAccountRepository,
  name: r'siteAccountRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$siteAccountRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SiteAccountRepositoryRef = ProviderRef<DataState<SiteAccount>>;
String _$accountRepositoryHash() => r'8d7e1c8414b9949a58bdd3b00556e7feed8da225';

/// See also [AccountRepository].
@ProviderFor(AccountRepository)
final accountRepositoryProvider =
    NotifierProvider<AccountRepository, DataState<Account>>.internal(
  AccountRepository.new,
  name: r'accountRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountRepository = Notifier<DataState<Account>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
