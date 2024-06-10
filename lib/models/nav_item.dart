import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nav_item.freezed.dart';

enum NavPath {
  home(
    name: 'home',
    path: '',
    param: null,
  ),
  users(
    name: 'users',
    path: 'users',
    param: 'user',
  ),
  groups(
    name: 'groups',
    path: 'groups',
    param: 'group',
  ),
  preferences(
    name: 'preferences',
    path: 'preferences',
  ),
  about(
    name: 'about',
    path: 'about',
  ),
  admin(
    name: 'admin',
    path: 'admin',
  );

  final String name;
  final String path;
  final String? param;

  const NavPath({
    required this.name,
    required this.path,
    this.param,
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
