// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'license_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LicenseEntry {
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LicenseEntryCopyWith<LicenseEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LicenseEntryCopyWith<$Res> {
  factory $LicenseEntryCopyWith(
          LicenseEntry value, $Res Function(LicenseEntry) then) =
      _$LicenseEntryCopyWithImpl<$Res, LicenseEntry>;
  @useResult
  $Res call({String title, String body});
}

/// @nodoc
class _$LicenseEntryCopyWithImpl<$Res, $Val extends LicenseEntry>
    implements $LicenseEntryCopyWith<$Res> {
  _$LicenseEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LicenseEntryImplCopyWith<$Res>
    implements $LicenseEntryCopyWith<$Res> {
  factory _$$LicenseEntryImplCopyWith(
          _$LicenseEntryImpl value, $Res Function(_$LicenseEntryImpl) then) =
      __$$LicenseEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String body});
}

/// @nodoc
class __$$LicenseEntryImplCopyWithImpl<$Res>
    extends _$LicenseEntryCopyWithImpl<$Res, _$LicenseEntryImpl>
    implements _$$LicenseEntryImplCopyWith<$Res> {
  __$$LicenseEntryImplCopyWithImpl(
      _$LicenseEntryImpl _value, $Res Function(_$LicenseEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
  }) {
    return _then(_$LicenseEntryImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LicenseEntryImpl implements _LicenseEntry {
  const _$LicenseEntryImpl({required this.title, required this.body});

  @override
  final String title;
  @override
  final String body;

  @override
  String toString() {
    return 'LicenseEntry(title: $title, body: $body)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LicenseEntryImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, body);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LicenseEntryImplCopyWith<_$LicenseEntryImpl> get copyWith =>
      __$$LicenseEntryImplCopyWithImpl<_$LicenseEntryImpl>(this, _$identity);
}

abstract class _LicenseEntry implements LicenseEntry {
  const factory _LicenseEntry(
      {required final String title,
      required final String body}) = _$LicenseEntryImpl;

  @override
  String get title;
  @override
  String get body;
  @override
  @JsonKey(ignore: true)
  _$$LicenseEntryImplCopyWith<_$LicenseEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
