// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conf.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Conf {
  String? get uiVersion => throw _privateConstructorUsedError;
  String? get desc => throw _privateConstructorUsedError;
  String? get forGuests => throw _privateConstructorUsedError;
  String? get forMembers => throw _privateConstructorUsedError;
  String? get forManagers => throw _privateConstructorUsedError;
  String? get forSubscriber => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConfCopyWith<Conf> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfCopyWith<$Res> {
  factory $ConfCopyWith(Conf value, $Res Function(Conf) then) =
      _$ConfCopyWithImpl<$Res, Conf>;
  @useResult
  $Res call(
      {String? uiVersion,
      String? desc,
      String? forGuests,
      String? forMembers,
      String? forManagers,
      String? forSubscriber});
}

/// @nodoc
class _$ConfCopyWithImpl<$Res, $Val extends Conf>
    implements $ConfCopyWith<$Res> {
  _$ConfCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uiVersion = freezed,
    Object? desc = freezed,
    Object? forGuests = freezed,
    Object? forMembers = freezed,
    Object? forManagers = freezed,
    Object? forSubscriber = freezed,
  }) {
    return _then(_value.copyWith(
      uiVersion: freezed == uiVersion
          ? _value.uiVersion
          : uiVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      desc: freezed == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      forGuests: freezed == forGuests
          ? _value.forGuests
          : forGuests // ignore: cast_nullable_to_non_nullable
              as String?,
      forMembers: freezed == forMembers
          ? _value.forMembers
          : forMembers // ignore: cast_nullable_to_non_nullable
              as String?,
      forManagers: freezed == forManagers
          ? _value.forManagers
          : forManagers // ignore: cast_nullable_to_non_nullable
              as String?,
      forSubscriber: freezed == forSubscriber
          ? _value.forSubscriber
          : forSubscriber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfImplCopyWith<$Res> implements $ConfCopyWith<$Res> {
  factory _$$ConfImplCopyWith(
          _$ConfImpl value, $Res Function(_$ConfImpl) then) =
      __$$ConfImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uiVersion,
      String? desc,
      String? forGuests,
      String? forMembers,
      String? forManagers,
      String? forSubscriber});
}

/// @nodoc
class __$$ConfImplCopyWithImpl<$Res>
    extends _$ConfCopyWithImpl<$Res, _$ConfImpl>
    implements _$$ConfImplCopyWith<$Res> {
  __$$ConfImplCopyWithImpl(_$ConfImpl _value, $Res Function(_$ConfImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uiVersion = freezed,
    Object? desc = freezed,
    Object? forGuests = freezed,
    Object? forMembers = freezed,
    Object? forManagers = freezed,
    Object? forSubscriber = freezed,
  }) {
    return _then(_$ConfImpl(
      uiVersion: freezed == uiVersion
          ? _value.uiVersion
          : uiVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      desc: freezed == desc
          ? _value.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      forGuests: freezed == forGuests
          ? _value.forGuests
          : forGuests // ignore: cast_nullable_to_non_nullable
              as String?,
      forMembers: freezed == forMembers
          ? _value.forMembers
          : forMembers // ignore: cast_nullable_to_non_nullable
              as String?,
      forManagers: freezed == forManagers
          ? _value.forManagers
          : forManagers // ignore: cast_nullable_to_non_nullable
              as String?,
      forSubscriber: freezed == forSubscriber
          ? _value.forSubscriber
          : forSubscriber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ConfImpl implements _Conf {
  const _$ConfImpl(
      {required this.uiVersion,
      required this.desc,
      required this.forGuests,
      required this.forMembers,
      required this.forManagers,
      required this.forSubscriber});

  @override
  final String? uiVersion;
  @override
  final String? desc;
  @override
  final String? forGuests;
  @override
  final String? forMembers;
  @override
  final String? forManagers;
  @override
  final String? forSubscriber;

  @override
  String toString() {
    return 'Conf(uiVersion: $uiVersion, desc: $desc, forGuests: $forGuests, forMembers: $forMembers, forManagers: $forManagers, forSubscriber: $forSubscriber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfImpl &&
            (identical(other.uiVersion, uiVersion) ||
                other.uiVersion == uiVersion) &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.forGuests, forGuests) ||
                other.forGuests == forGuests) &&
            (identical(other.forMembers, forMembers) ||
                other.forMembers == forMembers) &&
            (identical(other.forManagers, forManagers) ||
                other.forManagers == forManagers) &&
            (identical(other.forSubscriber, forSubscriber) ||
                other.forSubscriber == forSubscriber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uiVersion, desc, forGuests,
      forMembers, forManagers, forSubscriber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfImplCopyWith<_$ConfImpl> get copyWith =>
      __$$ConfImplCopyWithImpl<_$ConfImpl>(this, _$identity);
}

abstract class _Conf implements Conf {
  const factory _Conf(
      {required final String? uiVersion,
      required final String? desc,
      required final String? forGuests,
      required final String? forMembers,
      required final String? forManagers,
      required final String? forSubscriber}) = _$ConfImpl;

  @override
  String? get uiVersion;
  @override
  String? get desc;
  @override
  String? get forGuests;
  @override
  String? get forMembers;
  @override
  String? get forManagers;
  @override
  String? get forSubscriber;
  @override
  @JsonKey(ignore: true)
  _$$ConfImplCopyWith<_$ConfImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
