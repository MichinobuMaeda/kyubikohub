// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SiteAuth {
  String? get site => throw _privateConstructorUsedError;
  String? get uid => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SiteAuthCopyWith<SiteAuth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SiteAuthCopyWith<$Res> {
  factory $SiteAuthCopyWith(SiteAuth value, $Res Function(SiteAuth) then) =
      _$SiteAuthCopyWithImpl<$Res, SiteAuth>;
  @useResult
  $Res call({String? site, String? uid});
}

/// @nodoc
class _$SiteAuthCopyWithImpl<$Res, $Val extends SiteAuth>
    implements $SiteAuthCopyWith<$Res> {
  _$SiteAuthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? site = freezed,
    Object? uid = freezed,
  }) {
    return _then(_value.copyWith(
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SiteAuthImplCopyWith<$Res>
    implements $SiteAuthCopyWith<$Res> {
  factory _$$SiteAuthImplCopyWith(
          _$SiteAuthImpl value, $Res Function(_$SiteAuthImpl) then) =
      __$$SiteAuthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? site, String? uid});
}

/// @nodoc
class __$$SiteAuthImplCopyWithImpl<$Res>
    extends _$SiteAuthCopyWithImpl<$Res, _$SiteAuthImpl>
    implements _$$SiteAuthImplCopyWith<$Res> {
  __$$SiteAuthImplCopyWithImpl(
      _$SiteAuthImpl _value, $Res Function(_$SiteAuthImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? site = freezed,
    Object? uid = freezed,
  }) {
    return _then(_$SiteAuthImpl(
      site: freezed == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SiteAuthImpl with DiagnosticableTreeMixin implements _SiteAuth {
  const _$SiteAuthImpl({required this.site, required this.uid});

  @override
  final String? site;
  @override
  final String? uid;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SiteAuth(site: $site, uid: $uid)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SiteAuth'))
      ..add(DiagnosticsProperty('site', site))
      ..add(DiagnosticsProperty('uid', uid));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SiteAuthImpl &&
            (identical(other.site, site) || other.site == site) &&
            (identical(other.uid, uid) || other.uid == uid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, site, uid);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SiteAuthImplCopyWith<_$SiteAuthImpl> get copyWith =>
      __$$SiteAuthImplCopyWithImpl<_$SiteAuthImpl>(this, _$identity);
}

abstract class _SiteAuth implements SiteAuth {
  const factory _SiteAuth(
      {required final String? site,
      required final String? uid}) = _$SiteAuthImpl;

  @override
  String? get site;
  @override
  String? get uid;
  @override
  @JsonKey(ignore: true)
  _$$SiteAuthImplCopyWith<_$SiteAuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Account {
  String get id => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call({String id, DateTime? deletedAt});
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountImplCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$AccountImplCopyWith(
          _$AccountImpl value, $Res Function(_$AccountImpl) then) =
      __$$AccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime? deletedAt});
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
      _$AccountImpl _value, $Res Function(_$AccountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_$AccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$AccountImpl with DiagnosticableTreeMixin implements _Account {
  const _$AccountImpl({required this.id, required this.deletedAt});

  @override
  final String id;
  @override
  final DateTime? deletedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Account(id: $id, deletedAt: $deletedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Account'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('deletedAt', deletedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, deletedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);
}

abstract class _Account implements Account {
  const factory _Account(
      {required final String id,
      required final DateTime? deletedAt}) = _$AccountImpl;

  @override
  String get id;
  @override
  DateTime? get deletedAt;
  @override
  @JsonKey(ignore: true)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SiteAccount {
  String get account => throw _privateConstructorUsedError;
  String get site => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SiteAccountCopyWith<SiteAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SiteAccountCopyWith<$Res> {
  factory $SiteAccountCopyWith(
          SiteAccount value, $Res Function(SiteAccount) then) =
      _$SiteAccountCopyWithImpl<$Res, SiteAccount>;
  @useResult
  $Res call({String account, String site});
}

/// @nodoc
class _$SiteAccountCopyWithImpl<$Res, $Val extends SiteAccount>
    implements $SiteAccountCopyWith<$Res> {
  _$SiteAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = null,
    Object? site = null,
  }) {
    return _then(_value.copyWith(
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      site: null == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SiteAccountImplCopyWith<$Res>
    implements $SiteAccountCopyWith<$Res> {
  factory _$$SiteAccountImplCopyWith(
          _$SiteAccountImpl value, $Res Function(_$SiteAccountImpl) then) =
      __$$SiteAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String account, String site});
}

/// @nodoc
class __$$SiteAccountImplCopyWithImpl<$Res>
    extends _$SiteAccountCopyWithImpl<$Res, _$SiteAccountImpl>
    implements _$$SiteAccountImplCopyWith<$Res> {
  __$$SiteAccountImplCopyWithImpl(
      _$SiteAccountImpl _value, $Res Function(_$SiteAccountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = null,
    Object? site = null,
  }) {
    return _then(_$SiteAccountImpl(
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      site: null == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SiteAccountImpl with DiagnosticableTreeMixin implements _SiteAccount {
  const _$SiteAccountImpl({required this.account, required this.site});

  @override
  final String account;
  @override
  final String site;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SiteAccount(account: $account, site: $site)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SiteAccount'))
      ..add(DiagnosticsProperty('account', account))
      ..add(DiagnosticsProperty('site', site));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SiteAccountImpl &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.site, site) || other.site == site));
  }

  @override
  int get hashCode => Object.hash(runtimeType, account, site);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SiteAccountImplCopyWith<_$SiteAccountImpl> get copyWith =>
      __$$SiteAccountImplCopyWithImpl<_$SiteAccountImpl>(this, _$identity);
}

abstract class _SiteAccount implements SiteAccount {
  const factory _SiteAccount(
      {required final String account,
      required final String site}) = _$SiteAccountImpl;

  @override
  String get account;
  @override
  String get site;
  @override
  @JsonKey(ignore: true)
  _$$SiteAccountImplCopyWith<_$SiteAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
