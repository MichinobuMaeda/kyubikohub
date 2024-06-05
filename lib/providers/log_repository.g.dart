// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$logRepositoryHash() => r'ac09793f688ef21e95861521b13039799932447f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [logRepository].
@ProviderFor(logRepository)
const logRepositoryProvider = LogRepositoryFamily();

/// See also [logRepository].
class LogRepositoryFamily extends Family<AsyncValue<List<Log>>> {
  /// See also [logRepository].
  const LogRepositoryFamily();

  /// See also [logRepository].
  LogRepositoryProvider call({
    String? site,
  }) {
    return LogRepositoryProvider(
      site: site,
    );
  }

  @override
  LogRepositoryProvider getProviderOverride(
    covariant LogRepositoryProvider provider,
  ) {
    return call(
      site: provider.site,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'logRepositoryProvider';
}

/// See also [logRepository].
class LogRepositoryProvider extends StreamProvider<List<Log>> {
  /// See also [logRepository].
  LogRepositoryProvider({
    String? site,
  }) : this._internal(
          (ref) => logRepository(
            ref as LogRepositoryRef,
            site: site,
          ),
          from: logRepositoryProvider,
          name: r'logRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$logRepositoryHash,
          dependencies: LogRepositoryFamily._dependencies,
          allTransitiveDependencies:
              LogRepositoryFamily._allTransitiveDependencies,
          site: site,
        );

  LogRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.site,
  }) : super.internal();

  final String? site;

  @override
  Override overrideWith(
    Stream<List<Log>> Function(LogRepositoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LogRepositoryProvider._internal(
        (ref) => create(ref as LogRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        site: site,
      ),
    );
  }

  @override
  StreamProviderElement<List<Log>> createElement() {
    return _LogRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LogRepositoryProvider && other.site == site;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, site.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LogRepositoryRef on StreamProviderRef<List<Log>> {
  /// The parameter `site` of this provider.
  String? get site;
}

class _LogRepositoryProviderElement extends StreamProviderElement<List<Log>>
    with LogRepositoryRef {
  _LogRepositoryProviderElement(super.provider);

  @override
  String? get site => (origin as LogRepositoryProvider).site;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
