import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nav_item.freezed.dart';

@freezed
class NavItem with _$NavItem {
  const factory NavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required String path,
  }) = _NavItem;
}
