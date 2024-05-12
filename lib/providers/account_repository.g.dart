// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$siteAuthRepositoryHash() =>
    r'd916958e0d438cdf3bd0fb2458a9169da5b8b289';

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
    r'c14e80e656a64dab29a45f443703fdaa4b3e2ea9';

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
String _$accountRepositoryHash() => r'2be84edd9de254427b6a0a7c53369f3e91a3cddf';

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
