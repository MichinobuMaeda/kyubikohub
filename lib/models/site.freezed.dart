// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Site {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get forGuests => throw _privateConstructorUsedError;
  String get forMembers => throw _privateConstructorUsedError;
  String get forManagers => throw _privateConstructorUsedError;
  bool get deleted => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SiteCopyWith<Site> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SiteCopyWith<$Res> {
  factory $SiteCopyWith(Site value, $Res Function(Site) then) =
      _$SiteCopyWithImpl<$Res, Site>;
  @useResult
  $Res call(
      {String id,
      String name,
      String forGuests,
      String forMembers,
      String forManagers,
      bool deleted});
}

/// @nodoc
class _$SiteCopyWithImpl<$Res, $Val extends Site>
    implements $SiteCopyWith<$Res> {
  _$SiteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? forGuests = null,
    Object? forMembers = null,
    Object? forManagers = null,
    Object? deleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      forGuests: null == forGuests
          ? _value.forGuests
          : forGuests // ignore: cast_nullable_to_non_nullable
              as String,
      forMembers: null == forMembers
          ? _value.forMembers
          : forMembers // ignore: cast_nullable_to_non_nullable
              as String,
      forManagers: null == forManagers
          ? _value.forManagers
          : forManagers // ignore: cast_nullable_to_non_nullable
              as String,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SiteImplCopyWith<$Res> implements $SiteCopyWith<$Res> {
  factory _$$SiteImplCopyWith(
          _$SiteImpl value, $Res Function(_$SiteImpl) then) =
      __$$SiteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String forGuests,
      String forMembers,
      String forManagers,
      bool deleted});
}

/// @nodoc
class __$$SiteImplCopyWithImpl<$Res>
    extends _$SiteCopyWithImpl<$Res, _$SiteImpl>
    implements _$$SiteImplCopyWith<$Res> {
  __$$SiteImplCopyWithImpl(_$SiteImpl _value, $Res Function(_$SiteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? forGuests = null,
    Object? forMembers = null,
    Object? forManagers = null,
    Object? deleted = null,
  }) {
    return _then(_$SiteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      forGuests: null == forGuests
          ? _value.forGuests
          : forGuests // ignore: cast_nullable_to_non_nullable
              as String,
      forMembers: null == forMembers
          ? _value.forMembers
          : forMembers // ignore: cast_nullable_to_non_nullable
              as String,
      forManagers: null == forManagers
          ? _value.forManagers
          : forManagers // ignore: cast_nullable_to_non_nullable
              as String,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SiteImpl implements _Site {
  const _$SiteImpl(
      {required this.id,
      required this.name,
      required this.forGuests,
      required this.forMembers,
      required this.forManagers,
      required this.deleted});

  @override
  final String id;
  @override
  final String name;
  @override
  final String forGuests;
  @override
  final String forMembers;
  @override
  final String forManagers;
  @override
  final bool deleted;

  @override
  String toString() {
    return 'Site(id: $id, name: $name, forGuests: $forGuests, forMembers: $forMembers, forManagers: $forManagers, deleted: $deleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SiteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.forGuests, forGuests) ||
                other.forGuests == forGuests) &&
            (identical(other.forMembers, forMembers) ||
                other.forMembers == forMembers) &&
            (identical(other.forManagers, forManagers) ||
                other.forManagers == forManagers) &&
            (identical(other.deleted, deleted) || other.deleted == deleted));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, forGuests, forMembers, forManagers, deleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SiteImplCopyWith<_$SiteImpl> get copyWith =>
      __$$SiteImplCopyWithImpl<_$SiteImpl>(this, _$identity);
}

abstract class _Site implements Site {
  const factory _Site(
      {required final String id,
      required final String name,
      required final String forGuests,
      required final String forMembers,
      required final String forManagers,
      required final bool deleted}) = _$SiteImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get forGuests;
  @override
  String get forMembers;
  @override
  String get forManagers;
  @override
  bool get deleted;
  @override
  @JsonKey(ignore: true)
  _$$SiteImplCopyWith<_$SiteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
