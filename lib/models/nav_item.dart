import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nav_item.freezed.dart';

enum NavPath {
  home(
    name: 'home',
    path: '',
  ),
  me(
    name: 'me',
    path: 'me',
  ),
  about(
    name: 'about',
    path: 'about',
  );

  final String name;
  final String path;
  const NavPath({
    required this.name,
    required this.path,
  });
}

@freezed
class NavItem with _$NavItem {
  const factory NavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required NavPath navPath,
  }) = _NavItem;
}
