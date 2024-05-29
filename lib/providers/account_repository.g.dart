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
String _$siteAccountRepositoryHash() =>
    r'e6211bc108ebee0f47001936faa9ea4d02806998';

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
