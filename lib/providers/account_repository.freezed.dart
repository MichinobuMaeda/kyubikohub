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

  /// Create a copy of SiteAuth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of SiteAuth
  /// with the given fields replaced by the non-null parameter values.
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

  /// Create a copy of SiteAuth
  /// with the given fields replaced by the non-null parameter values.
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

  /// Create a copy of SiteAuth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of SiteAuth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SiteAuthImplCopyWith<_$SiteAuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Account {
  String get site => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String? get user => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call({String site, String id, String? user, DateTime? deletedAt});
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? site = null,
    Object? id = null,
    Object? user = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      site: null == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
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
  $Res call({String site, String id, String? user, DateTime? deletedAt});
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
      _$AccountImpl _value, $Res Function(_$AccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? site = null,
    Object? id = null,
    Object? user = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$AccountImpl(
      site: null == site
          ? _value.site
          : site // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$AccountImpl with DiagnosticableTreeMixin implements _Account {
  const _$AccountImpl(
      {required this.site,
      required this.id,
      required this.user,
      required this.deletedAt});

  @override
  final String site;
  @override
  final String id;
  @override
  final String? user;
  @override
  final DateTime? deletedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Account(site: $site, id: $id, user: $user, deletedAt: $deletedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Account'))
      ..add(DiagnosticsProperty('site', site))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('user', user))
      ..add(DiagnosticsProperty('deletedAt', deletedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountImpl &&
            (identical(other.site, site) || other.site == site) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, site, id, user, deletedAt);

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);
}

abstract class _Account implements Account {
  const factory _Account(
      {required final String site,
      required final String id,
      required final String? user,
      required final DateTime? deletedAt}) = _$AccountImpl;

  @override
  String get site;
  @override
  String get id;
  @override
  String? get user;
  @override
  DateTime? get deletedAt;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AccountStatus {
  Account? get account => throw _privateConstructorUsedError;
  bool get manager => throw _privateConstructorUsedError;
  bool get admin => throw _privateConstructorUsedError;

  /// Create a copy of AccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountStatusCopyWith<AccountStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountStatusCopyWith<$Res> {
  factory $AccountStatusCopyWith(
          AccountStatus value, $Res Function(AccountStatus) then) =
      _$AccountStatusCopyWithImpl<$Res, AccountStatus>;
  @useResult
  $Res call({Account? account, bool manager, bool admin});

  $AccountCopyWith<$Res>? get account;
}

/// @nodoc
class _$AccountStatusCopyWithImpl<$Res, $Val extends AccountStatus>
    implements $AccountStatusCopyWith<$Res> {
  _$AccountStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = freezed,
    Object? manager = null,
    Object? admin = null,
  }) {
    return _then(_value.copyWith(
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account?,
      manager: null == manager
          ? _value.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as bool,
      admin: null == admin
          ? _value.admin
          : admin // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of AccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountCopyWith<$Res>? get account {
    if (_value.account == null) {
      return null;
    }

    return $AccountCopyWith<$Res>(_value.account!, (value) {
      return _then(_value.copyWith(account: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountStatusImplCopyWith<$Res>
    implements $AccountStatusCopyWith<$Res> {
  factory _$$AccountStatusImplCopyWith(
          _$AccountStatusImpl value, $Res Function(_$AccountStatusImpl) then) =
      __$$AccountStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Account? account, bool manager, bool admin});

  @override
  $AccountCopyWith<$Res>? get account;
}

/// @nodoc
class __$$AccountStatusImplCopyWithImpl<$Res>
    extends _$AccountStatusCopyWithImpl<$Res, _$AccountStatusImpl>
    implements _$$AccountStatusImplCopyWith<$Res> {
  __$$AccountStatusImplCopyWithImpl(
      _$AccountStatusImpl _value, $Res Function(_$AccountStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = freezed,
    Object? manager = null,
    Object? admin = null,
  }) {
    return _then(_$AccountStatusImpl(
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account?,
      manager: null == manager
          ? _value.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as bool,
      admin: null == admin
          ? _value.admin
          : admin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AccountStatusImpl
    with DiagnosticableTreeMixin
    implements _AccountStatus {
  const _$AccountStatusImpl(
      {required this.account, required this.manager, required this.admin});

  @override
  final Account? account;
  @override
  final bool manager;
  @override
  final bool admin;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountStatus(account: $account, manager: $manager, admin: $admin)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AccountStatus'))
      ..add(DiagnosticsProperty('account', account))
      ..add(DiagnosticsProperty('manager', manager))
      ..add(DiagnosticsProperty('admin', admin));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountStatusImpl &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.manager, manager) || other.manager == manager) &&
            (identical(other.admin, admin) || other.admin == admin));
  }

  @override
  int get hashCode => Object.hash(runtimeType, account, manager, admin);

  /// Create a copy of AccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountStatusImplCopyWith<_$AccountStatusImpl> get copyWith =>
      __$$AccountStatusImplCopyWithImpl<_$AccountStatusImpl>(this, _$identity);
}

abstract class _AccountStatus implements AccountStatus {
  const factory _AccountStatus(
      {required final Account? account,
      required final bool manager,
      required final bool admin}) = _$AccountStatusImpl;

  @override
  Account? get account;
  @override
  bool get manager;
  @override
  bool get admin;

  /// Create a copy of AccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountStatusImplCopyWith<_$AccountStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AuthUser {
  String get uid => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthUserCopyWith<AuthUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) then) =
      _$AuthUserCopyWithImpl<$Res, AuthUser>;
  @useResult
  $Res call({String uid, String? email});
}

/// @nodoc
class _$AuthUserCopyWithImpl<$Res, $Val extends AuthUser>
    implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthUserImplCopyWith<$Res>
    implements $AuthUserCopyWith<$Res> {
  factory _$$AuthUserImplCopyWith(
          _$AuthUserImpl value, $Res Function(_$AuthUserImpl) then) =
      __$$AuthUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uid, String? email});
}

/// @nodoc
class __$$AuthUserImplCopyWithImpl<$Res>
    extends _$AuthUserCopyWithImpl<$Res, _$AuthUserImpl>
    implements _$$AuthUserImplCopyWith<$Res> {
  __$$AuthUserImplCopyWithImpl(
      _$AuthUserImpl _value, $Res Function(_$AuthUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = freezed,
  }) {
    return _then(_$AuthUserImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AuthUserImpl with DiagnosticableTreeMixin implements _AuthUser {
  const _$AuthUserImpl({required this.uid, required this.email});

  @override
  final String uid;
  @override
  final String? email;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthUser(uid: $uid, email: $email)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthUser'))
      ..add(DiagnosticsProperty('uid', uid))
      ..add(DiagnosticsProperty('email', email));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, email);

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUserImplCopyWith<_$AuthUserImpl> get copyWith =>
      __$$AuthUserImplCopyWithImpl<_$AuthUserImpl>(this, _$identity);
}

abstract class _AuthUser implements AuthUser {
  const factory _AuthUser(
      {required final String uid,
      required final String? email}) = _$AuthUserImpl;

  @override
  String get uid;
  @override
  String? get email;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUserImplCopyWith<_$AuthUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
