// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nav_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NavItem {
  IconData get icon => throw _privateConstructorUsedError;
  IconData get selectedIcon => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  NavPath get navPath => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NavItemCopyWith<NavItem> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NavItemCopyWith<$Res> {
  factory $NavItemCopyWith(NavItem value, $Res Function(NavItem) then) =
      _$NavItemCopyWithImpl<$Res, NavItem>;
  @useResult
  $Res call(
      {IconData icon, IconData selectedIcon, String label, NavPath navPath});
}

/// @nodoc
class _$NavItemCopyWithImpl<$Res, $Val extends NavItem>
    implements $NavItemCopyWith<$Res> {
  _$NavItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? selectedIcon = null,
    Object? label = null,
    Object? navPath = null,
  }) {
    return _then(_value.copyWith(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      selectedIcon: null == selectedIcon
          ? _value.selectedIcon
          : selectedIcon // ignore: cast_nullable_to_non_nullable
              as IconData,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      navPath: null == navPath
          ? _value.navPath
          : navPath // ignore: cast_nullable_to_non_nullable
              as NavPath,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NavItemImplCopyWith<$Res> implements $NavItemCopyWith<$Res> {
  factory _$$NavItemImplCopyWith(
          _$NavItemImpl value, $Res Function(_$NavItemImpl) then) =
      __$$NavItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {IconData icon, IconData selectedIcon, String label, NavPath navPath});
}

/// @nodoc
class __$$NavItemImplCopyWithImpl<$Res>
    extends _$NavItemCopyWithImpl<$Res, _$NavItemImpl>
    implements _$$NavItemImplCopyWith<$Res> {
  __$$NavItemImplCopyWithImpl(
      _$NavItemImpl _value, $Res Function(_$NavItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? selectedIcon = null,
    Object? label = null,
    Object? navPath = null,
  }) {
    return _then(_$NavItemImpl(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as IconData,
      selectedIcon: null == selectedIcon
          ? _value.selectedIcon
          : selectedIcon // ignore: cast_nullable_to_non_nullable
              as IconData,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      navPath: null == navPath
          ? _value.navPath
          : navPath // ignore: cast_nullable_to_non_nullable
              as NavPath,
    ));
  }
}

/// @nodoc

class _$NavItemImpl implements _NavItem {
  const _$NavItemImpl(
      {required this.icon,
      required this.selectedIcon,
      required this.label,
      required this.navPath});

  @override
  final IconData icon;
  @override
  final IconData selectedIcon;
  @override
  final String label;
  @override
  final NavPath navPath;

  @override
  String toString() {
    return 'NavItem(icon: $icon, selectedIcon: $selectedIcon, label: $label, navPath: $navPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavItemImpl &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.selectedIcon, selectedIcon) ||
                other.selectedIcon == selectedIcon) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.navPath, navPath) || other.navPath == navPath));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, icon, selectedIcon, label, navPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NavItemImplCopyWith<_$NavItemImpl> get copyWith =>
      __$$NavItemImplCopyWithImpl<_$NavItemImpl>(this, _$identity);
}

abstract class _NavItem implements NavItem {
  const factory _NavItem(
      {required final IconData icon,
      required final IconData selectedIcon,
      required final String label,
      required final NavPath navPath}) = _$NavItemImpl;

  @override
  IconData get icon;
  @override
  IconData get selectedIcon;
  @override
  String get label;
  @override
  NavPath get navPath;
  @override
  @JsonKey(ignore: true)
  _$$NavItemImplCopyWith<_$NavItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
