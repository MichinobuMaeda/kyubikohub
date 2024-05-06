// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tab_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TabItem {
  IconData get icon => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  Widget get page => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TabItemCopyWith<TabItem> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TabItemCopyWith<$Res> {
  factory $TabItemCopyWith(TabItem value, $Res Function(TabItem) then) =
      _$TabItemCopyWithImpl<$Res, TabItem>;
  @useResult
  $Res call({IconData icon, String label, Widget page});
}

/// @nodoc
class _$TabItemCopyWithImpl<$Res, $Val extends TabItem>
    implements $TabItemCopyWith<$Res> {
  _$TabItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? label = null,
    Object? page = null,
  }) {
    return _then(_value.copyWith(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as Widget,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TabItemImplCopyWith<$Res> implements $TabItemCopyWith<$Res> {
  factory _$$TabItemImplCopyWith(
          _$TabItemImpl value, $Res Function(_$TabItemImpl) then) =
      __$$TabItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({IconData icon, String label, Widget page});
}

/// @nodoc
class __$$TabItemImplCopyWithImpl<$Res>
    extends _$TabItemCopyWithImpl<$Res, _$TabItemImpl>
    implements _$$TabItemImplCopyWith<$Res> {
  __$$TabItemImplCopyWithImpl(
      _$TabItemImpl _value, $Res Function(_$TabItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? label = null,
    Object? page = null,
  }) {
    return _then(_$TabItemImpl(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as Widget,
    ));
  }
}

/// @nodoc

class _$TabItemImpl implements _TabItem {
  const _$TabItemImpl(
      {required this.icon, required this.label, required this.page});

  @override
  final IconData icon;
  @override
  final String label;
  @override
  final Widget page;

  @override
  String toString() {
    return 'TabItem(icon: $icon, label: $label, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TabItemImpl &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(runtimeType, icon, label, page);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TabItemImplCopyWith<_$TabItemImpl> get copyWith =>
      __$$TabItemImplCopyWithImpl<_$TabItemImpl>(this, _$identity);
}

abstract class _TabItem implements TabItem {
  const factory _TabItem(
      {required final IconData icon,
      required final String label,
      required final Widget page}) = _$TabItemImpl;

  @override
  IconData get icon;
  @override
  String get label;
  @override
  Widget get page;
  @override
  @JsonKey(ignore: true)
  _$$TabItemImplCopyWith<_$TabItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
